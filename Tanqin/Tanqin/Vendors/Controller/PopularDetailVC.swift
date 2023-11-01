import UIKit
import SnapKit
import CRRefresh

class PopularDetailVC: BaseController {
    
    var popular: PopularLayout = .added
    
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
    
    fileprivate let headerTitle: UILabel = {
        let view = UILabel()
        view.font = UIFont.bold(of: 24)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.text = ""
        return view
    }()
    
    fileprivate let listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: Home9AnimeItemCell.self)
        view.registerItem(cell: HomeAniwareItemCell.self)
        view.registerItem(cell: AdmobNativeAdCell.self)
        view.registerItem(cell: AppLovinNativeAdCell.self)
        return view
    }()
    
    var page: Int = 1
    var dataAnime: [AniModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = self
        self.headerTitle.text = self.popular.getTitle()
        self.backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        self.loadData()
        self.listCollectionView.cr.addFootRefresh { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadData(){
        if self.popular == .updated {
            if HTMLService.shared.getSourceAnime() == .anime9 {
                HTMLService.shared.recentlyUpdated(page: page) { data in
                    self.dataAnime += data
                    self.reloadDataCallApi()
                }
            }
            else {
                AnWHTMLService.shared.updated(page: page) { data in
                    self.dataAnime += data
                    self.reloadDataCallApi()
                }
            }
        } else if self.popular == .added {
            if HTMLService.shared.getSourceAnime() == .anime9 {
                HTMLService.shared.recentlyAdded(page: page) { data in
                    self.dataAnime += data
                    self.reloadDataCallApi()
                }
            }
            else {
                AnWHTMLService.shared.added(page: page) { data in
                    self.dataAnime += data
                    self.reloadDataCallApi()
                }
            }
        } else if self.popular == .ongoing {
            if HTMLService.shared.getSourceAnime() == .anime9 {
                HTMLService.shared.ongoing(page: page) { data in
                    self.dataAnime += data
                    self.reloadDataCallApi()
                }
            }
            else {
                AnWHTMLService.shared.ongoing(page: page) { data in
                    self.dataAnime += data
                    self.reloadDataCallApi()
                }
            }
        } else if self.popular == .upcoming {
            HTMLService.shared.upcoming(page: page) { data in
                self.dataAnime += data
                self.reloadDataCallApi()
            }
        } else if self.popular == .newest {
            AnWHTMLService.shared.newest(page: page) { data in
                self.dataAnime += data
                self.reloadDataCallApi()
            }
        } else if self.popular == .completed {
            AnWHTMLService.shared.completed(page: page) { data in
                self.dataAnime += data
                self.reloadDataCallApi()
            }
        }
    }
    
    func reloadDataCallApi(){
        DispatchQueue.main.async {
            self.listCollectionView.cr.endLoadingMore()
            self.listCollectionView.reloadData()
            if super.admobAd == nil && super.applovinAdView == nil {
                if !super.loadedNative {
                    super.loadNativeAd { [weak self] in
                        self?.listCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initView(){
        self.view.addSubview(viewContent)
        viewContent.layoutSafeAreaEdges()
        self.viewContent.addSubview(backButton)
        self.viewContent.addSubview(headerTitle)
        self.viewContent.addSubview(listCollectionView)
        
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        self.headerTitle.snp.makeConstraints { make in
            make.leading.equalTo(self.backButton.snp.trailing)
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.listCollectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.headerTitle.snp.bottom).offset(0)
        }
    }
}

extension PopularDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return super.numberOfNatives()
        }
        return dataAnime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if super.admobAd != nil {
                let cell: AdmobNativeAdCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.nativeAd = super.admobAd
                return cell
            }
            else if super.applovinAdView != nil {
                let cell: AppLovinNativeAdCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.nativeAd = super.applovinAdView
                return cell
            }
            else {
                return UICollectionViewCell()
            }
        } else {
            if HTMLService.shared.getSourceAnime() == .anime9 {
                let cell: Home9AnimeItemCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.aniModel = dataAnime[indexPath.row]
                return cell
            } else {
                let cell: HomeAniwareItemCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.aniModel = dataAnime[indexPath.row]
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.gotoDetailAnime(anime: dataAnime[indexPath.row])
    }
}

extension PopularDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if super.admobAd != nil {
                return AdmobNativeAdCell.size(collectionView.frame.size.width)
            }
            else if super.applovinAdView != nil {
                return AppLovinNativeAdCell.size(collectionView.frame.size.width)
            }
            return .zero
        }
        var width = ((collectionView.frame.size.width-16)/3) - 1
        if UIDevice.isIPad {
            width = ((collectionView.frame.size.width-32)/5) - 1
        }
        return .init(width: width, height: 47 + width*176/123)
    }
}
