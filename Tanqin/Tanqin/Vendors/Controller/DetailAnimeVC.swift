import UIKit
import SnapKit
import Countly

enum DetailLayout {
    case info, describe, episodes, suggest, more_info ,ads
}

class DetailAnimeVC: BaseController {
    
    var numberLineDes = 5
    
    fileprivate let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate let backButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "ic-back"), for: .normal)
        return view
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: DetailInfoCell.self)
        view.registerItem(cell: DetailMoreInfoCell.self)
        view.registerItem(cell: DetailDescribeCell.self)
        view.registerItem(cell: DetailEpisodesCell.self)
        view.registerItem(cell: DetailSuggestCell.self)
        view.registerItem(cell: AdmobNativeAdCell.self)
        view.registerItem(cell: AppLovinNativeAdCell.self)
        view.registerItem(cell: BaseCollectionCell.self)
        return view
    }()
    
    fileprivate let layouts: [DetailLayout] = [.info, .ads, .describe, .more_info, .episodes, .suggest]
    fileprivate let layoutsNotMoreInfo: [DetailLayout] = [.info, .ads, .describe, .episodes, .suggest]
    
    var aniModel: AniModel!
    var aniDetailModel: AniDetailModel?
    var typeSort: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        self.backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Log anime detail
        let event = ["anime_detail" : "\(HTMLService.shared.getSourceAnime().getTitleSource()) - \(aniModel.detailLink)"]
        Countly.sharedInstance().recordEvent("anime_detail", segmentation:event)
        NetworksService.shared.loadInfo(link: aniModel.detailLink, title: aniModel.enName) { [weak self] detail in
            self?.aniDetailModel = detail
            self?.collectionView.reloadData()
            
            if detail != nil && detail!.isEmpty == false {
                self?.loadAds()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    private func loadAds() {
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initView(){
        self.view.addSubview(viewContent)
        viewContent.layoutSafeAreaEdges()
        self.viewContent.addSubview(collectionView)
        self.viewContent.addSubview(backButton)
        
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(self.backButton.snp.bottom).offset(0)
        }
    }
}

extension DetailAnimeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.aniDetailModel == nil {
            return 0
        } else {
            if self.numberLineDes == 0 {
                return layouts.count
            } else {
                return layoutsNotMoreInfo.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var layout = layoutsNotMoreInfo
        if self.numberLineDes == 0 {
            layout = layouts
        }
        switch layout[indexPath.row] {
        case .info:
            let cell: DetailInfoCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.aniDetailModel
            cell.onSelectedWatchNow = {
                if (self.aniDetailModel?.episode ?? []).count > 0{
                    self.watchAnime(episode: (self.aniDetailModel?.episode ?? []).last!)
                }
            }
            
            cell.onSelectedContinueWatch = {
                self.continueWatchAnime()
            }
            
            return cell
        case .more_info:
            let cell: DetailMoreInfoCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.aniDetailModel
            cell.numberLineDes = self.numberLineDes
            cell.onSelectedReadmore = {
                if self.numberLineDes == 0 {
                    self.numberLineDes = 5
                } else {
                    self.numberLineDes = 0
                }
                self.collectionView.reloadData()
            }
            return cell
        case .describe:
            let cell: DetailDescribeCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.aniDetailModel
            cell.numberLineDes = self.numberLineDes
            cell.onSelectedReadmore = {
                if self.numberLineDes == 0 {
                    self.numberLineDes = 5
                } else {
                    self.numberLineDes = 0
                }
                self.collectionView.reloadData()
            }
            return cell
        case .episodes:
            let cell: DetailEpisodesCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.typeSort = self.typeSort
            cell.aniEpisodes = self.aniDetailModel?.episode ?? []
            cell.changeSort = {
                if self.typeSort == 0 {
                    self.typeSort = 1
                } else {
                    self.typeSort = 0
                }
                self.collectionView.reloadData()
            }
            cell.onSelected = { aniEpisode in
                self.watchAnime(episode: aniEpisode)
            }
            return cell
        case .suggest:
            let cell: DetailSuggestCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.aniDetailModel?.suggestion ?? []
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            return cell
        case .ads:
            if super.admobAd != nil {
                let cell: AdmobNativeAdCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.nativeAd = super.admobAd
                return cell
            } else if super.applovinAdView != nil {
                let cell: AppLovinNativeAdCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.nativeAd = super.applovinAdView
                return cell
            } else {
                let cell: BaseCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                return cell
            }
        }
    }
    
    func watchAnime(episode: AniEpisodesModel) {
        let link = aniModel.detailLink
        let name = aniModel.enName
        
        let recentAni = RecentAni()
        recentAni.id = aniDetailModel!.id
        recentAni.posterLink = aniModel.posterLink
        recentAni.enName = aniModel.enName
        recentAni.detailLink = aniModel.detailLink
        recentAni.source = HTMLService.shared.getSourceAnime().getTitleSource()
        recentAni.season = episode.season
        recentAni.episode = episode.sourceID
        recentAni.sourceId = episode.sourceID
        RecentAni.addRecentAni(recentAni: recentAni)
        
        NetworksService.shared.loadInfoas(link: link, title: name, season: episode.season, episode: episode.sourceID) { [weak self] data in
            if data.count == 0 {
                self?.alertNotLink {
                    let event = ["link_anime" : "\(HTMLService.shared.getSourceAnime().getTitleSource()) - \(name) - \(episode.season) - \(episode.sourceID)"]
                    Countly.sharedInstance().recordEvent("link_anime_failed", segmentation:event)
                }
                return
            }
            
            if UserDefaults.standard.integer(forKey: "willpl") > 0 {
                AdsInterstitialHandle.shared.tryToPresent {
                    self?.ooplay(name: name, link: link, data: data, episode: episode)
                }
            }
            else {
                self?.ooplay(name: name, link: link, data: data, episode: episode)
            }
        }
    }
    
    func continueWatchAnime() {
        let recentAni = RecentAni.getRecentAni(id: aniDetailModel?.id ?? "")
        if recentAni != nil {
            let link = recentAni!.detailLink
            let name = recentAni!.enName
            for episode in (self.aniDetailModel?.episode ?? []) {
                if episode.season == recentAni?.season && episode.episode == recentAni?.episode {
                    
                    let recentAni = RecentAni()
                    recentAni.id = aniDetailModel!.id
                    recentAni.posterLink = aniModel.posterLink
                    recentAni.enName = aniModel.enName
                    recentAni.detailLink = aniModel.detailLink
                    recentAni.source = HTMLService.shared.getSourceAnime().getTitleSource()
                    recentAni.season = episode.season
                    recentAni.episode = episode.sourceID
                    recentAni.sourceId = episode.sourceID
                    RecentAni.addRecentAni(recentAni: recentAni)
                    
                    NetworksService.shared.loadInfoas(link: link, title: name, season: episode.season, episode: episode.sourceID) { [weak self] data in
                        if data.count == 0 {
                            self?.alertNotLink {
                                let event = ["link_anime" : "\(HTMLService.shared.getSourceAnime().getTitleSource()) - \(name) - \(episode.season) - \(episode.sourceID)"]
                                Countly.sharedInstance().recordEvent("link_anime_failed", segmentation:event)
                            }
                            return
                        }
                        
                        if UserDefaults.standard.integer(forKey: "willpl") > 0 {
                            AdsInterstitialHandle.shared.tryToPresent {
                                self?.ooplay(name: name, link: link, data: data, episode: episode)
                            }
                        }
                        else {
                            self?.ooplay(name: name, link: link, data: data, episode: episode)
                        }
                    }
                }
            }
        }
    }
    
    func ooplay(name: String, link: String, data: [TaqiDictionary], episode: AniEpisodesModel) {
        let player = TaqPlayerController.makeController()
        player.link = link
        player.name = name
        player.data = data
        player.episode = episode
        player.typeSort = self.typeSort
        player.episodes = self.aniDetailModel?.episode ?? []
        self.present(player, animated: true)
    }
}

extension DetailAnimeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: kPadding, bottom: 0, right: kPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.size.width - 2 * kPadding
        var layout = layoutsNotMoreInfo
        if self.numberLineDes == 0 {
            layout = layouts
        }
        switch layout[indexPath.row] {
        case .info:
            return DetailInfoCell.size(width: width)
        case .describe:
            let heightAll = heightForLabel(text: aniDetailModel?.description ?? "", font: UIFont.regular(of: 14)!, width: width, numberLine: 0)
            let heightRead = heightForLabel(text: aniDetailModel?.description ?? "", font: UIFont.regular(of: 14)!, width: width, numberLine: numberLineDes)
            if numberLineDes == 0 {
                return .init(width: width, height: heightAll)
            } else {
                if heightAll <= heightRead {
                    return .init(width: width, height: heightAll + 32)
                } else {
                    return .init(width: width, height: heightRead + 32)
                }
            }
        case .more_info:
            if numberLineDes == 0 {
                return .init(width: width, height: 272)
            } else {
                return .init(width: width, height: 0)
            }
        case .episodes:
            var height = 0
            
            let totalEpisode = (self.aniDetailModel?.episode ?? []).count
            if totalEpisode < numberEpisodes*numberRowEpisodes {
                if totalEpisode % numberEpisodes == 0 {
                    height = 40 + totalEpisode / numberEpisodes * heightEpisodesCell
                } else {
                    height = 40 + (totalEpisode / numberEpisodes + 1) * heightEpisodesCell
                }
            } else {
                height = 40 + heightEpisodesCell * numberRowEpisodes
            }
            return .init(width: width, height: CGFloat(height))
        case .suggest:
            if (self.aniDetailModel?.suggestion ?? []).count == 0 {
                return .zero
            } else {
                return DetailSuggestCell.size(width: width)
            }
        case .ads:
            if super.admobAd != nil {
                return AdmobNativeAdCell.size(width)
            }
            else if super.applovinAdView != nil {
                return AppLovinNativeAdCell.size(width)
            }
            return .zero
        }
    }
}
