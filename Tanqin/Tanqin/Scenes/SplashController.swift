//
//  SplashController.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 23/10/2023.
//

import UIKit
import Lottie
import AppLovinSDK
import GoogleMobileAds
import UserMessagingPlatform
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
    
    fileprivate var isMobileAdsStartCalled = false
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
        fetchConsent()
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
    
    // MARK: - consent
    fileprivate func fetchConsent() {
        // Create a UMPRequestParameters object.
        let parameters = UMPRequestParameters()
        // Set tag for under age of consent. false means users are not under age of consent.
        parameters.tagForUnderAgeOfConsent = false
        
#if DEBUG
        let debugSettings = UMPDebugSettings()
        debugSettings.testDeviceIdentifiers = []
        debugSettings.geography = .EEA
        
        parameters.debugSettings = debugSettings
#endif
        
        // Request an update for the consent information.
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) { [weak self] requestConsentError in
            guard let self else {
                self?.requestTracking()
                self?.triggerTimer()
                return
            }
            
            if let consentError = requestConsentError {
                self.requestTracking()
                self.triggerTimer()
                // Consent gathering failed.
                return print("Error: \(consentError.localizedDescription)")
            }
            
            UMPConsentForm.loadAndPresentIfRequired(from: self) { [weak self] loadAndPresentError in
                guard let self else {
                    self?.requestTracking()
                    self?.triggerTimer()
                    return
                }
                
                if let consentError = loadAndPresentError {
                    self.requestTracking()
                    self.triggerTimer()
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }
                
                // Consent has been gathered.
                if UMPConsentInformation.sharedInstance.canRequestAds {
                    self.startGoogleMobileAdsSDK()
                }
            }
        }
        
        // Check if you can initialize the Google Mobile Ads SDK in parallel
        // while checking for new consent information. Consent obtained in
        // the previous session can be used to request ads.
        if UMPConsentInformation.sharedInstance.canRequestAds {
            startGoogleMobileAdsSDK()
        }
    }
    
    fileprivate func requestTracking() {
        IDIFAService.shared.requestTracking { }
    }
    
    fileprivate func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            
            self.isMobileAdsStartCalled = true
            self.requestTracking()
            
#if DEBUG
            AdmobController.shared.idsTest = []
#endif
            
            AdmobController.shared.awake { [weak self] in
                self?.processLogicSplashAd()
                
                AdmobOpenController.shared.preloadAdIfNeed()
            }
        }
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name("czuupt"), object: nil, queue: .main) { _ in            
            let navigationController = BaseNavigation(rootViewController: MainTabbaController())
            navigationController.setNavigationBarHidden(true, animated: false)
            
            UIWindow.keyWindow?.rootViewController = navigationController
        }
    }
    
    fileprivate func processLogicSplashAd() {
        let splTimeOut = UserDefaults.standard.integer(forKey: "splash-timeout")
        let splash = UserDefaults.standard.string(forKey: "splash") ?? ""
        
        if IDIFAService.shared.requestedIDFA && splash == AdsName.admob.rawValue {
            self.timeout = splTimeOut > 0 ? TimeInterval(splTimeOut) : 10.0
            
            if AdmobController.shared.isReady {
                self.loadSplashAdmob()
                self.triggerTimer()
            }
            else {
                self.willLoadAdmob = true
            }
        }
        else if IDIFAService.shared.requestedIDFA && splash == AdsName.applovin.rawValue {
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
    }
    
    // MARK: - timer
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
        NotificationCenter.default.post(name: NSNotification.Name("oaiqomqr"), object: nil)
    }
    
    @objc func countDown() {
        timeout -= 1.0
        
        if timeout <= 0 {
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
