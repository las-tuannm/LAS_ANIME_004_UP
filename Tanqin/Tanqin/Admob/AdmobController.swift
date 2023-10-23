//
//  AdmobController.swift
//  Tanqin
//
//  Created by HaKT on 22/10/2023.
//

import UIKit
import GoogleMobileAds

class AdmobController: NSObject {
    
    // MARK: - properties
    private var _isReady = false
    
    var isReady: Bool {
        guard let _ = GlobalDataModel.shared.adsAvailableFor(.admob) else {
            return false
        }
        
        return _isReady
    }
    
    var idsTest: [String] = []
    
    // MARK: - initial
    static let shared = AdmobController()
    
    // MARK: private
    
    // MARK: public
    func awake(completion: @escaping () -> Void) {
        var ids: [String] = idsTest
        ids.append(GADSimulatorID)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ids
        GADMobileAds.sharedInstance().start { _ in
            self._isReady = true
            completion()
            NotificationCenter.default.post(name: .admobAvailable, object: nil)
        }
    }
}
