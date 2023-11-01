//
//  ApplovinOpenController.swift
//  Tanqin
//
//  Created by HaKT on 22/10/2023.
//

import UIKit
import AppLovinSDK

class ApplovinOpenController: NSObject {
    
    // MARK: - properties
    private var _appOpenAd: MAAppOpenAd?
    
    // MARK: - initial
    @objc static let shared = ApplovinOpenController()
    
    override init() {
        super.init()
    }
    
    // MARK: - private
    
    // MARK: -
    var canShowAds: Bool {
        if !ApplovinController.shared.isReady {
            return false
        }
        
        if GlobalDataModel.shared.applovin_appopen.isEmpty {
            return false
        }
        
        if !GlobalDataModel.shared.isAvailable(.applovin, .open) {
            return false
        }
        
        return true
    }
    
    var isReady: Bool {
        return _appOpenAd != nil
    }
    
    // MARK: - public
    func preloadAd(completion: ((_ success: Bool) -> Void)?) {
        self._appOpenAd = nil
        
        guard canShowAds else {
            completion?(false)
            return
        }
        
        self._appOpenAd = MAAppOpenAd(adUnitIdentifier: GlobalDataModel.shared.applovin_appopen)
        self._appOpenAd?.delegate = self
        self._appOpenAd?.load()
    }
    
    func preloadAdIfNeed() {
        if self._appOpenAd == nil {
            self.preloadAd(completion: nil)
        }
    }
    
    @discardableResult
    func tryToPresent() -> Bool {
        guard isReady else {
            if _appOpenAd == nil {
                self.awake()
            }
            return false
        }
        
        if (_appOpenAd?.isReady ?? false) {
            if let window = UIWindow.keyWindow,
               let rootController = window.topMost,
               let presented = rootController.presentedViewController
            {
//                if presented is TaqPlayerController {
//                    return false
//                }
            }
            
            _appOpenAd?.show()
            return true
        }
        else {
            _appOpenAd?.load()
            return false
        }
    }
    
    func awake() {
        self.preloadAd(completion: nil)
    }
    
}

extension ApplovinOpenController: MAAdDelegate {
    func didLoad(_ ad: MAAd) {
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        self._appOpenAd?.load()
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        self._appOpenAd?.load()
    }
}
