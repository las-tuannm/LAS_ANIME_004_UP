import UIKit
import SnapKit
import Lottie

enum PopularLayout {
    case updated, ads, added, ongoing, upcoming, newest, completed
    
    func getTitle() -> String {
        switch self {
        case .updated:
            return "Updated"
        case .added:
            return "Added"
        case .ongoing:
            return "Ongoing"
        case .upcoming:
            return "Upcoming"
        case .newest:
            return "Newest"
        case .completed:
            return "Completed"
        case .ads:
            return ""
        }
    }
    
}

class PopularVC: BaseController {
    
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
        view.text = "Popular"
        return view
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.registerItem(cell: PopularUpdateCell.self)
        view.registerItem(cell: PopularAddedCell.self)
        view.registerItem(cell: PopularOngoingCell.self)
        view.registerItem(cell: PopularUpcomingCell.self)
        view.registerItem(cell: PopularNewestCell.self)
        view.registerItem(cell: PopularCompletedCell.self)
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
    private let loadingView = LoadingView()
    
    var update: [AniModel] = [AniModel]()
    var added: [AniModel] = [AniModel]()
    var ongoing: [AniModel] = [AniModel]()
    var upcoming: [AniModel] = [AniModel]()
    var newest: [AniModel] = [AniModel]()
    var completed: [AniModel] = [AniModel]()
    
    fileprivate var layouts: [PopularLayout] {
        get {
            if HTMLService.shared.getSourceAnime() == .anime9 {
                return [.updated, .ads, .added, .ongoing, .upcoming]
            }
            else {
                return [.newest, .ads, .updated, .ongoing, .added, .completed]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update.append(AniModel(id: "", enName: "", jpName: "", posterLink: "", detailLink: "", quality: "", sub: "", eps: ""))
        added.append(AniModel(id: "", enName: "", jpName: "", posterLink: "", detailLink: "", quality: "", sub: "", eps: ""))
        ongoing.append(AniModel(id: "", enName: "", jpName: "", posterLink: "", detailLink: "", quality: "", sub: "", eps: ""))
        upcoming.append(AniModel(id: "", enName: "", jpName: "", posterLink: "", detailLink: "", quality: "", sub: "", eps: ""))
        newest.append(AniModel(id: "", enName: "", jpName: "", posterLink: "", detailLink: "", quality: "", sub: "", eps: ""))
        completed.append(AniModel(id: "", enName: "", jpName: "", posterLink: "", detailLink: "", quality: "", sub: "", eps: ""))
        
        initView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getData()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("change_source"), object: nil, queue: .main) { [unowned self] _ in
            self.getData()
        }
    }
    
    func getData() {
        if HTMLService.shared.getSourceAnime() == .anime9 {
            HTMLService.shared.recentlyUpdated(page: 1) { data in
                self.update = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
            
            HTMLService.shared.recentlyAdded(page: 1) { data in
                self.added = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
            
            HTMLService.shared.ongoing(page: 1) { data in
                self.ongoing = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
            
            HTMLService.shared.upcoming(page: 1) { data in
                self.upcoming = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
        }
        else {
            AnWHTMLService.shared.newest(page: 1) { data in
                self.newest = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
            AnWHTMLService.shared.updated(page: 1) { data in
                self.update = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
            AnWHTMLService.shared.ongoing(page: 1) { data in
                self.ongoing = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
            AnWHTMLService.shared.added(page: 1) { data in
                self.added = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
            AnWHTMLService.shared.completed(page: 1) { data in
                self.completed = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkReloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !super.loadedNative {
            super.loadNativeAd { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    func initView(){
        self.view.addSubview(viewContent)
        self.viewContent.layoutSafeAreaEdges()
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
        self.loadingView.show()
        getData()
    }
    
    func checkReloadData(){
        self.loadingView.dismiss()
        if HTMLService.shared.getSourceAnime() == .anime9 {
            if (self.update.isEmpty && self.added.isEmpty && self.ongoing.isEmpty && self.upcoming.isEmpty) {
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
        } else {
            if (self.newest.isEmpty && self.update.isEmpty && self.ongoing.isEmpty && self.added.isEmpty && self.completed.isEmpty) {
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

extension PopularVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layouts[indexPath.row] {
        case .updated:
            let cell: PopularUpdateCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.update
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            cell.onMore = {
                self.gotoDetailPopular(popoular: .updated)
            }
            
            cell.onReload = {
                self.loadingView.show()
                if HTMLService.shared.getSourceAnime() == .anime9 {
                    HTMLService.shared.recentlyAdded(page: 1) { data in
                        self.added = data
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.loadingView.dismiss()
                        }
                    }
                } else {
                    AnWHTMLService.shared.updated(page: 1) { data in
                        self.update = data
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.loadingView.dismiss()
                        }
                    }
                }
            }
            
            return cell
        case .added:
            let cell: PopularAddedCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.added
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            cell.onMore = {
                self.gotoDetailPopular(popoular: .added)
            }
            
            cell.onReload = {
                self.loadingView.show()
                if HTMLService.shared.getSourceAnime() == .anime9 {
                    HTMLService.shared.recentlyUpdated(page: 1) { data in
                        self.update = data
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.loadingView.dismiss()
                        }
                    }
                } else {
                    AnWHTMLService.shared.added(page: 1) { data in
                        self.added = data
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.loadingView.dismiss()
                        }
                    }
                }
            }
            
            return cell
        case .ongoing:
            let cell: PopularOngoingCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.ongoing
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            cell.onMore = {
                self.gotoDetailPopular(popoular: .ongoing)
            }
            
            cell.onReload = {
                self.loadingView.show()
                if HTMLService.shared.getSourceAnime() == .anime9 {
                    HTMLService.shared.ongoing(page: 1) { data in
                        self.ongoing = data
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.loadingView.dismiss()
                        }
                    }
                } else {
                    AnWHTMLService.shared.ongoing(page: 1) { data in
                        self.ongoing = data
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.loadingView.dismiss()
                        }
                    }
                }
            }
            
            return cell
        case .upcoming:
            let cell: PopularUpcomingCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.upcoming
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            cell.onMore = {
                self.gotoDetailPopular(popoular: .upcoming)
            }
            
            cell.onReload = {
                self.loadingView.show()
                HTMLService.shared.upcoming(page: 1) { data in
                    self.upcoming = data
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.loadingView.dismiss()
                    }
                }
            }
            
            return cell
        case .newest:
            let cell: PopularNewestCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.newest
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            cell.onMore = {
                self.gotoDetailPopular(popoular: .newest)
            }
            
            cell.onReload = {
                self.loadingView.show()
                AnWHTMLService.shared.newest(page: 1) { data in
                    self.newest = data
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.loadingView.dismiss()
                    }
                }
            }
            
            return cell
        case .completed:
            let cell: PopularCompletedCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.data = self.completed
            cell.onSelected = { animodel in
                self.gotoDetailAnime(anime: animodel)
            }
            cell.onMore = {
                self.gotoDetailPopular(popoular: .completed)
            }
            
            cell.onReload = {
                self.loadingView.show()
                AnWHTMLService.shared.completed(page: 1) { data in
                    self.completed = data
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.loadingView.dismiss()
                    }
                }
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
            }
            else {
                let cell: BaseCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                return cell
            }
        }
        
    }
}

extension PopularVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.size.width - 2 * kPadding
        switch layouts[indexPath.row] {
        case .updated:
            return PopularUpdateCell.size(width: width)
        case .added:
            return PopularAddedCell.size(width: width)
        case .ongoing:
            return PopularOngoingCell.size(width: width)
        case .upcoming:
            return PopularUpcomingCell.size(width: width)
        case .newest:
            return PopularNewestCell.size(width: width)
        case .completed:
            return PopularCompletedCell.size(width: width)
        case .ads:
            if HTMLService.shared.getSourceAnime() == .anime9 {
                if self.update.isEmpty && self.added.isEmpty && self.ongoing.isEmpty && self.upcoming.isEmpty {
                    return .zero
                }
            } else {
                if self.newest.isEmpty && self.update.isEmpty && self.ongoing.isEmpty && self.added.isEmpty && self.completed.isEmpty{
                    return .zero
                }
            }
            
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
