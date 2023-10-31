//
//  AdmobInterController.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 31/10/2023.
//

import UIKit
import GoogleMobileAds

class AdmobInterController: BaseInterstitial {
    
    // MARK: - properties
    private var _interstitial: GADInterstitialAd?
    private var _closeHandler: (() -> Void)?
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: - override from supper
    override var canShowAds: Bool {
        if !AdmobController.shared.isReady {
            return false
        }
        
        if GlobalDataModel.shared.admob_inter.isEmpty {
            return false
        }
        
        if !GlobalDataModel.shared.isAvailable(.admob, .interstitial) {
            return false
        }
        
        return true
    }
    
    override var isReady: Bool {
        return _interstitial != nil
    }
    
    override func preloadAd(completion: @escaping (Bool) -> Void) {
        self._interstitial = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        let id = GlobalDataModel.shared.admob_inter
        GADInterstitialAd.load(withAdUnitID: id, request: GADRequest()) { ad, error in
            if ad != nil {
                self._interstitial = ad
                self._interstitial?.fullScreenContentDelegate = self
                completion(true)
            }
            else {
                self._interstitial = nil
                if error != nil {
                }
                completion(false)
            }
        }
    }
    
    override func tryToPresent(with closeHandler: @escaping () -> Void) {
        self._closeHandler = nil
        
        guard isReady else {
            closeHandler()
            return
        }
        
        guard let rootController = UIWindow.keyWindow?.topMost else {
            closeHandler()
            return
        }
        
        if let presented = rootController.presentedViewController {
            self._closeHandler = closeHandler
            self._interstitial?.present(fromRootViewController: presented)
        }
        else {
            self._closeHandler = closeHandler
            self._interstitial?.present(fromRootViewController: rootController)
        }
    }
}

extension AdmobInterController: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if let handler = self._closeHandler {
            handler()
            self._closeHandler = nil
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if let handler = self._closeHandler {
            handler()
            self._closeHandler = nil
        }
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        
    }
}
