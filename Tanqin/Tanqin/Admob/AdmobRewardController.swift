//
//  AdmobRewardController.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 31/10/2023.
//

import UIKit
import GoogleMobileAds

class AdmobRewardController: NSObject {
    
    // MARK: - properties
    private var _rewardedAd: GADRewardedAd?
    
    // MARK: - initial
    override init() {
        super.init()
    }
    
    // MARK: private
    
    // MARK: -
    var canShowAds: Bool {
        if !AdmobController.shared.isReady {
            return false
        }
        
        if GlobalDataModel.shared.admob_reward.isEmpty {
            return false
        }
        
        if !GlobalDataModel.shared.isAvailable(.admob, .reward) {
            return false
        }
        
        return true
    }
    
    var isReady: Bool {
        return _rewardedAd != nil
    }
    
    // MARK: - public
    func preloadAd(completion: @escaping (_ success: Bool) -> Void) {
        self._rewardedAd = nil
        
        guard canShowAds else {
            completion(false)
            return
        }
        
        let id = GlobalDataModel.shared.admob_reward
        GADRewardedAd.load(withAdUnitID: id, request: GADRequest()) { ad, error in
            if ad != nil {
                self._rewardedAd = ad
                self._rewardedAd?.fullScreenContentDelegate = self
                completion(true)
            }
            else if error != nil {
                self._rewardedAd = nil
                completion(false)
            }
        }
    }
    
    func tryToPresentDidEarnReward(with handler: @escaping () -> Void) {
        guard isReady else { return }
        
        guard let rootController = UIWindow.keyWindow?.topMost else { return }
        
        if let presented = rootController.presentedViewController {
            if presented is TaqPlayerController {
            }
            else {
                _rewardedAd?.present(fromRootViewController: presented, userDidEarnRewardHandler: handler)
            }
        }
        else {
            _rewardedAd?.present(fromRootViewController: rootController, userDidEarnRewardHandler: handler)
        }
    }
}

extension AdmobRewardController: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        
    }
}
