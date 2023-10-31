//
//  ApplovinRewardController.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 31/10/2023.
//

import UIKit
import AppLovinSDK

class ApplovinRewardController: NSObject {
    
    // MARK: - properties
    private var _rewardedAd: MARewardedAd?
    private var _loadHandler: ((_ success: Bool) -> Void)?
    private var _didEarnHandler: (() -> Void)?
    
    // MARK:
    var canShowAds: Bool {
        if !ApplovinController.shared.isReady {
            return false
        }
        
        if GlobalDataModel.shared.applovin_reward.isEmpty {
            return false
        }
        
        return true
    }
    
    var isReady: Bool {
        return _rewardedAd != nil && _rewardedAd!.isReady
    }
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: - public
    func preloadAd(completion: @escaping (_ isSuccess: Bool) -> Void) {
        self._loadHandler = nil
        self._rewardedAd = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        self._loadHandler = completion
        
        _rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: GlobalDataModel.shared.applovin_reward)
        _rewardedAd?.delegate = self
        _rewardedAd?.revenueDelegate = self
        _rewardedAd?.load()
    }
    
    func tryToPresentDidEarnReward(with handler: @escaping () -> Void) {
        self._didEarnHandler = nil
        
        guard isReady else { return }
        
        self._didEarnHandler = handler
        self._rewardedAd?.show()
    }
    
}

extension ApplovinRewardController: MARewardedAdDelegate, MAAdRevenueDelegate {
    func didStartRewardedVideo(for ad: MAAd) {
        
    }
    
    func didCompleteRewardedVideo(for ad: MAAd) {
        
    }
    
    func didRewardUser(for ad: MAAd, with reward: MAReward) {
        if let handler = self._didEarnHandler {
            handler()
            self._didEarnHandler = nil
        }
    }
    
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
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        
    }
}
