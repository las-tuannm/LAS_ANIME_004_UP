//
//  SplashController.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 23/10/2023.
//

import UIKit
import Lottie
import GoogleMobileAds
import AppLovinSDK
import AppTrackingTransparency

class SplashController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private var hasIDFA: Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
        }
        return true
    }
    private var timer: Timer?
    private var timeout: TimeInterval = 3.0
    
    fileprivate var willLoadAdmob: Bool = false
    fileprivate var popupAdmob: GADInterstitialAd?
    
    fileprivate var willLoadApplovin: Bool = false
    fileprivate var popupApplovin: MAInterstitialAd?
    
    fileprivate let animationView = LottieAnimationView(name: "loadingT")
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UserDefaults.standard.set(1, forKey: "openning_splash")
        UserDefaults.standard.synchronize()
        
        setupViews()
        
        let splTimeOut = UserDefaults.standard.integer(forKey: "splash-timeout")
        let splash = UserDefaults.standard.string(forKey: "splash") ?? ""
        
        if hasIDFA && splash == AdsName.admob.rawValue {
            self.timeout = splTimeOut > 0 ? TimeInterval(splTimeOut) : 10.0
            
            if AdmobController.shared.isReady {
                self.loadSplashAdmob()
                self.triggerTimer()
            }
            else {
                self.willLoadAdmob = true
            }
        }
        else if hasIDFA && splash == AdsName.applovin.rawValue {
            self.timeout = splTimeOut > 0 ? TimeInterval(splTimeOut) : 10.0
            
            if ApplovinController.shared.isReady {
                self.loadSplashApplovin()
                self.triggerTimer()
            }
            else {
                self.willLoadApplovin = true
            }
        }
        else {
            self.triggerTimer()
        }
        registerObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { _ in })
    }
    
    fileprivate func setupViews() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)
        
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    fileprivate func registerObserver() {
        NotificationCenter.default.addObserver(forName: .admobAvailable, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            if self.willLoadAdmob {
                self.loadSplashAdmob()
                self.triggerTimer()
            }
        }
        NotificationCenter.default.addObserver(forName: .applovinAvailable, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            if self.willLoadApplovin {
                self.loadSplashApplovin()
                self.triggerTimer()
            }
        }
    }
    
    fileprivate func triggerTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(countDown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    fileprivate func openHomeMain() {
        UserDefaults.standard.set(0, forKey: "openning_splash")
        UserDefaults.standard.synchronize()
        
        let navigationController = BaseNavigation(rootViewController: MainTabbaController())
        navigationController.setNavigationBarHidden(true, animated: false)
        
        UIWindow.keyWindow?.rootViewController = navigationController
    }
    
    @objc func countDown() {
        timeout -= 1
        
        if timeout == 0 {
            timer?.invalidate()
            timer = nil
            
            openHomeMain()
        }
    }
    
    // MARK: - logic ad
    private func loadSplashAdmob() {
        GADInterstitialAd.load(withAdUnitID: GlobalDataModel.shared.admob_inter_splash, request: GADRequest()) { [weak self] ad, error in
            guard let self = self else { return }
            
            self.timer?.invalidate()
            self.timer = nil
            
            if ad != nil {
                self.popupAdmob = ad
                self.popupAdmob?.fullScreenContentDelegate = self
                self.popupAdmob?.present(fromRootViewController: self)
            }
            else {
                self.popupAdmob = nil
                self.openHomeMain()
            }
        }
    }
    
    private func loadSplashApplovin() {
        popupApplovin = MAInterstitialAd(adUnitIdentifier: GlobalDataModel.shared.applovin_inter_splash)
        popupApplovin?.delegate = self
        popupApplovin?.revenueDelegate = self
        popupApplovin?.load()
    }
    
}

extension SplashController: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.openHomeMain()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.openHomeMain()
    }
}

extension SplashController: MAAdRevenueDelegate, MAAdViewAdDelegate {
    func didPayRevenue(for ad: MAAd) { }
    
    func didLoad(_ ad: MAAd) {
        self.timer?.invalidate()
        self.timer = nil
        
        if popupApplovin?.isReady ?? false {
            popupApplovin?.show()
        }
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        self.timer?.invalidate()
        self.timer = nil
        
        self.openHomeMain()
    }
    
    func didExpand(_ ad: MAAd) { }
    
    func didCollapse(_ ad: MAAd) { }
    
    func didDisplay(_ ad: MAAd) { }
    
    func didHide(_ ad: MAAd) {
        self.openHomeMain()
    }
    
    func didClick(_ ad: MAAd) { }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        self.openHomeMain()
    }
}
