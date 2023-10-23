//
//  AdmobOpenController.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 22/10/2023.
//

import UIKit
import GoogleMobileAds

class AdmobOpenController: NSObject {
    
    // MARK: - properties
    private var _openAd: GADAppOpenAd?
    private var _loadTime: Date?
    
    // MARK: - initial
    @objc static let shared = AdmobOpenController()
    
    override init() {
        super.init()
    }
    
    // MARK: private
    private func validateLoadTime() -> Bool {
        guard let loadTime = self._loadTime else { return true}
        
        let now = Date()
        let intervals = now.timeIntervalSince(loadTime)
        return intervals < 4 * 60 * 60
    }
    
    // MARK: -
    var canShowAds: Bool {
        if !AdmobController.shared.isReady {
            return false
        }
        
        if GlobalDataModel.shared.admob_appopen.isEmpty {
            return false
        }
        
        if !GlobalDataModel.shared.isAvailable(.admob, .open) {
            return false
        }
        
        return true
    }
    
    var isReady: Bool {
        return _openAd != nil && validateLoadTime()
    }
    
    // MARK: - public
    func preloadAd(completion: ((_ success: Bool) -> Void)?) {
        self._openAd = nil
        self._loadTime = nil
        
        guard canShowAds else {
            completion?(false)
            return
        }
        
        //
        let id = GlobalDataModel.shared.admob_appopen
        
        GADAppOpenAd.load(withAdUnitID: id, request: GADRequest(), orientation: .portrait) { ad, error in
            if ad != nil {
                
                self._openAd = ad
                self._openAd?.fullScreenContentDelegate = self
                self._loadTime = Date()
                completion?(true)
            }
            else if error != nil {
                self._openAd = nil
                completion?(false)
            }
        }
    }
    
    func preloadAdIfNeed() {
        if _openAd == nil {
            self.preloadAd(completion: nil)
        }
    }
    
    @objc func tryToPresent() -> Bool {
        guard isReady else {
            if _openAd == nil {
                self.awake()
            }
            return false
        }
        
        guard let window = UIWindow.keyWindow,
              let root = window.topMost else { return false }
        
        if let presented = root.presentedViewController {
            _openAd?.present(fromRootViewController: presented)
        }
        else {
            _openAd?.present(fromRootViewController: root)
        }
        
        return true
    }
    
    @objc func awake() {
        self.preloadAd(completion: nil)
    }
}

extension AdmobOpenController: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.preloadAd(completion: nil)
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        
    }
}
