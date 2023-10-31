import UIKit
import SnapKit
import Lottie

private enum HomeLayout {
    case recentUpdate, ads, trending, top, recentWatch
}

class HomeVC: BaseController {

    fileprivate let viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate let headerTitle: UILabel = {
        let view = UILabel()
        view.font = UIFont.bold(of: 24)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.text = "Anime"
        return view
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: HomeRecentCell.self)
        view.registerItem(cell: HomeContinueCell.self)
        view.registerItem(cell: HomeTrendingCell.self)
        view.registerItem(cell: HomeTopCell.self)
        view.registerItem(cell: AdmobNativeAdCell.self)
        view.registerItem(cell: AppLovinNativeAdCell.self)
        view.registerItem(cell: BaseCollectionCell.self)
        return view
    }()
    
    fileprivate let reloadButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Reload data", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.medium(of: 14)
        view.backgroundColor = .init(UIColor(rgb: 0x7938C3))
        view.layer.cornerRadius = 16
        view.isHidden = true
        return view
    }()
    
    fileprivate let viewAnim: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        return view
    }()
    
    private let animationView = LottieAnimationView(name: "empty_json")
    
    var recentWatch: [RecentAni] = [RecentAni]()
    var trending: [AniModel] = [AniModel]()
    var recently: [AniModel] = [AniModel]()
    var today: [AniModel] = [AniModel]()
    var week: [AniModel] = [AniModel]()
    var month: [AniModel] = [AniModel]()
        
    fileprivate let layouts: [HomeLayout] = [.trending, .ads, .recentWatch, .recentUpdate, .top]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getData()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("change_source"), object: nil, queue: .main) { [unowned self] _ in
            self.getData()
        }
    }
    
    func getData(){
        
        recentWatch = RecentAni.getAllRecentAni()
        
        if HTMLService.shared.getSourceAnime() == .anime9 {
            HTMLService.shared.home { trending, recently, today, week, month, genre in
                self.trending = trending
                self.recently = recently
                self.today = today
                self.week = week
                self.month = month
                
                DispatchQueue.main.async {
                    if let tabbar = UIWindow.keyWindow?.mainTabbar1 {
                        tabbar.genres = genre
                    }
                    self.collectionView.reloadData()
                    
                    if (self.trending.isEmpty && self.recently.isEmpty && self.today.isEmpty && self.week.isEmpty && self.month.isEmpty) {
                        self.reloadButton.isHidden = false
                        self.viewAnim.isHidden = false
                        self.collectionView.isHidden = true
                        self.animationView.play(fromProgress: 0,
                                           toProgress: 1,
                                           loopMode: LottieLoopMode.loop,
                                           completion: { (finished) in})
                    } else {
                        self.reloadButton.isHidden = true
                        self.viewAnim.isHidden = true
                        self.collectionView.isHidden = false
                    }
                    
                }
            }
        }
        else {
            AnWHTMLService.shared.home { trending, recently, today, week, month, genre in
                self.trending = trending
                self.recently = recently
                self.today = today
                self.week = week
                self.month = month
                
                DispatchQueue.main.async {
                    if let tabbar = UIWindow.keyWindow?.mainTabbar1 {
                        tabbar.genres = genre
                    }
                    self.collectionView.reloadData()
                    if (self.trending.isEmpty && self.recently.isEmpty && self.today.isEmpty && self.week.isEmpty && self.month.isEmpty) {
                        self.reloadButton.isHidden = false
                        self.viewAnim.isHidden = false
                        self.collectionView.isHidden = true
                        self.animationView.play(fromProgress: 0,
                                           toProgress: 1,
                                           loopMode: LottieLoopMode.loop,
                                           completion: { (finished) in})
                    } else {
                        self.reloadButton.isHidden = true
                        self.viewAnim.isHidden = true
                        self.collectionView.isHidden = false
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recentWatch = RecentAni.getAllRecentAni()
        self.collectionView.reloadData()
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    func initView(){
        self.view.addSubview(viewContent)
        viewContent.layoutSafeAreaEdges()
        self.viewContent.addSubview(headerTitle)
        self.viewContent.addSubview(collectionView)
        self.viewContent.addSubview(reloadButton)
        self.viewContent.addSubview(viewAnim)
        self.viewAnim.addSubview(animationView)
        self.headerTitle.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(self.headerTitle.snp.bottom).offset(0)
        }
        
        self.reloadButton.snp.makeConstraints { make in
            make.center.equalTo(self.collectionView.snp.center)
            make.height.equalTo(32)
            make.width.equalTo(120)
        }
        
        self.viewAnim.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.reloadButton.snp.top).offset(16)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        self.animationView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.reloadButton.addTarget(self, action: #selector(reloadClick), for: .touchUpInside)
        
    }
    
    @objc func reloadClick() {
        getData()
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layouts[indexPath.row] {
        case .recentUpdate:
            let cell: HomeRecentCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.recently
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            return cell
        case .recentWatch:
            let cell: HomeContinueCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.recentWatch
            cell.onSelected = { recentAnime in
                self.gotoDetailRecentAnime(recentAni: recentAnime)
            }
            return cell
        case .trending:
            let cell: HomeTrendingCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.trending
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            return cell
        case .top:
            let cell: HomeTopCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.setData(today: self.today, week: self.week, month: self.month)
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
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
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
        switch layouts[indexPath.row] {
        case .recentUpdate:
            return HomeRecentCell.size(width: width)
        case .recentWatch:
            if self.recentWatch.count == 0 {
                return.zero
            } else {
                return HomeContinueCell.size(width: width)
            }
        case .trending:
            return HomeTrendingCell.size(width: width)
        case .top:
            if self.today.count == 0 && self.week.count == 0 && self.month.count == 0 {
                return .init(width: width, height: 0)
            } else {
                return .init(width: width, height: 856)
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
