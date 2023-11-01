//
//  ApplovinNativeItem.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 31/10/2023.
//

import UIKit
import AppLovinSDK

class ApplovinNativeItem: NSObject {
    
    // MARK: - properties
    private (set) var _nativeAds: MAAd?
    private (set) var _nativeAdView: UIView?
    private (set) var _adLoader: MANativeAdLoader?
    
    fileprivate var _nativeDidReceive: ((_ nativeAdView: MANativeAdView, _ nativeAd: MAAd) -> Void)!
    fileprivate var _nativeDidFail: ((_ error: Error?) -> Void)!
    
    // MARK: - initial
    init(nativeDidReceive: @escaping ((_ nativeAdView: MANativeAdView, _ nativeAd: MAAd) -> Void),
         nativeDidFail: @escaping ((_ error: Error?) -> Void))
    {
        self._nativeDidReceive = nativeDidReceive
        self._nativeDidFail = nativeDidFail
    }
    
    // MARK: -
    var canShowAds: Bool {
        if !ApplovinController.shared.isReady {
            return false
        }
        
        if GlobalDataModel.shared.applovin_small_native.isEmpty {
            return false
        }
        
        if !GlobalDataModel.shared.isAvailable(.applovin, .native) {
            return false
        }
        
        if _adLoader != nil {
            return false
        }
        
        return true
    }
    
    // MARK: public
    func preloadAd(controller: UIViewController) {
        guard canShowAds else {
            _nativeDidFail(nil)
            return
        }
        
        _adLoader = MANativeAdLoader(adUnitIdentifier: GlobalDataModel.shared.applovin_small_native)
        _adLoader?.nativeAdDelegate = self
        _adLoader?.loadAd()
    }
}

extension ApplovinNativeItem: MANativeAdDelegate {
    func didLoadNativeAd(_ nativeAdView: MANativeAdView?, for ad: MAAd) {
        guard let adView = nativeAdView else {
            _nativeDidFail(NSError.make(code: 1003, userInfo: ["message": "Ad view is nil"]))
            return
        }
        
        // Clean up any pre-existing native ad to prevent memory leaks
        if let currentNativeAd = _nativeAds {
            _adLoader?.destroy(currentNativeAd)
        }
        
        // Save ad for cleanup
        _nativeAds = ad
        _nativeAdView = adView
        
        _nativeDidReceive(adView, ad)
    }
    
    func didFailToLoadNativeAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        _nativeDidFail(NSError.make(code: -1, userInfo: ["message": error.message]))
    }
    
    func didClickNativeAd(_ ad: MAAd) {
    }
}
