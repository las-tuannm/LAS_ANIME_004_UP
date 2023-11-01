//
//  ApplovinInterController.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 31/10/2023.
//

import UIKit
import AppLovinSDK

class ApplovinInterController: BaseInterstitial {
    
    // MARK: - properties
    private var _interstitialAd: MAInterstitialAd?
    private var _loadHandler: ((_ success: Bool) -> Void)?
    private var _closeHandler: (() -> Void)?
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: -
    override var canShowAds: Bool {
        if !ApplovinController.shared.isReady {
            return false
        }
        
        if GlobalDataModel.shared.applovin_inter.isEmpty {
            return false
        }
        
        if !GlobalDataModel.shared.isAvailable(.applovin, .interstitial) {
            return false
        }
        
        return true
    }
    
    override var isReady: Bool {
        return _interstitialAd != nil && _interstitialAd!.isReady
    }
    
    // MARK: -
    override func preloadAd(completion: @escaping (_ success: Bool) -> Void) {
        self._loadHandler = nil
        self._interstitialAd = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        self._loadHandler = completion
        
        _interstitialAd = MAInterstitialAd(adUnitIdentifier: GlobalDataModel.shared.applovin_inter)
        _interstitialAd?.delegate = self
        _interstitialAd?.revenueDelegate = self
        _interstitialAd?.load()
    }
    
    override func tryToPresent(with closeHandler: @escaping () -> Void) {
        self._closeHandler = nil
        
        guard isReady else {
            closeHandler()
            return
        }
        
        self._closeHandler = closeHandler
        self._interstitialAd?.show()
    }
    
    
}

extension ApplovinInterController: MAAdRevenueDelegate, MAAdViewAdDelegate {
    func didPayRevenue(for ad: MAAd) {
        
    }
    
    func didLoad(_ ad: MAAd) {
        if let handler = self._loadHandler {
            handler(true)
            self._loadHandler = nil
        }
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        if let handler = self._loadHandler {
            handler(false)
            self._loadHandler = nil
        }
    }
    
    func didExpand(_ ad: MAAd) {
        
    }
    
    func didCollapse(_ ad: MAAd) {
        
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        if let handler = self._closeHandler {
            handler()
            self._closeHandler = nil
        }
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        if let handler = self._closeHandler {
            handler()
            self._closeHandler = nil
        }
    }
}
