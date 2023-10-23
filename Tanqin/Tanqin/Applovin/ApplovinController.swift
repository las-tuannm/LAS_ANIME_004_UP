//
//  ApplovinController.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 22/10/2023.
//

import UIKit
import AppLovinSDK
import AdSupport

class ApplovinController: NSObject {
    
    // MARK: - properties
    private var _isReady = false
    
    var isReady: Bool {
        return _isReady
    }
    
    // MARK: - initial
    @objc static let shared = ApplovinController()
    
    // MARK: private
    
    // MARK: public
    func awake(completion: @escaping () -> Void) {
        if ALSdk.shared() == nil {
            return
        }
        
#if DEBUG
        let uuid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        ALSdk.shared()!.settings.testDeviceAdvertisingIdentifiers = [uuid]
#endif
        
        ALSdk.shared()!.mediationProvider = "max"
        ALSdk.shared()!.initializeSdk { (configuration: ALSdkConfiguration) in
            self._isReady = true
            completion()
        }
    }
}
