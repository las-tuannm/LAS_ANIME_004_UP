import UIKit
import GoogleMobileAds
import AppLovinSDK
import AppTrackingTransparency
import SnapKit
import Countly

class BaseController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - Native Ad
    var nativeIndex: Int = 0
    var loadedNative: Bool = false
    
    fileprivate var admobNative: AdmobNativeItem?
    fileprivate var applovinNative: ApplovinNativeItem?
    
    var admobAd: GADNativeAd?
    var applovinAdView: MANativeAdView?
    let loadView = PALoadingView()
    
    fileprivate let gradientView: GradientView = {
        let view = GradientView()
        view.startColor = UIColor.init(rgb: 0x2122FF).withAlphaComponent(0.15)
        view.endColor = UIColor.clear
        return view
    }()
    
    private func hasRequestTrackingIDFA() -> Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
        }
        else {
            return true
        }
    }
    
    func loadNativeAd(_ completion: @escaping () -> Void) {
        if hasRequestTrackingIDFA() == false {
            return
        }
        
        let nativesAvailable = GlobalDataModel.shared.adsAvailableFor(.native)
        if nativeIndex >= nativesAvailable.count {
            return
        }
        
        let name = nativesAvailable[nativeIndex].name
        nativeIndex += 1
        
        switch name {
        case .admob:
            if admobNative != nil { return }
            
            admobNative = AdmobNativeItem(numberOfAds: 1, nativeDidReceive: { [weak self] natives in
                if natives.first != nil {
                    self?.loadedNative = true
                    self?.admobAd = natives.first
                    completion()
                }
            }, nativeDidFail: { [weak self] error in
                self?.loadNativeAd(completion)
            })
            admobNative?.preloadAd(controller: self)
            
        case .applovin:
            if applovinNative != nil { return }
            
            applovinNative = ApplovinNativeItem(nativeDidReceive: { [weak self] (nativeAdView, nativeAd) in
                self?.loadedNative = true
                self?.applovinAdView = nativeAdView
                completion()
            }, nativeDidFail: { [weak self] error in
                self?.loadNativeAd(completion)
            })
            applovinNative?.preloadAd(controller: self)
            
        }
    }
    
    func numberOfNatives() -> Int {
        return admobAd != nil || applovinAdView != nil ? 1 : 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgb: 0x050506)
        self.loadView.setMessage("Loading ads...")
        self.view.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func gotoDetailPopular(popoular: PopularLayout) {
        let vc = PopularDetailVC()
        vc.popular = popoular
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoDetailGenre(aniGenre: AniGenreModel){
        let vc = GenresDetailVC()
        vc.aniGenre = aniGenre
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoDetailRecentAnime(recentAni: RecentAni) {
        let ani = AniModel(id: recentAni.id,
                           enName: recentAni.enName,
                           jpName: "",
                           posterLink: recentAni.posterLink,
                           detailLink: recentAni.detailLink,
                           quality: "",
                           sub: "",
                           eps: "")
        gotoDetailAnime(anime: ani)
    }
    
    func gotoDetailAnime(anime: AniModel) {
        AdsInterstitialHandle.shared.tryToPresent {
            if HTMLService.shared.getSourceAnime() == .anime9 {
                let vc = DetailAnimeVC()
                vc.aniModel = anime
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = DetailAniwareVC()
                vc.aniModel = anime
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
