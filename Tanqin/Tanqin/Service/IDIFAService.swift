//
//  IDIFAService.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 13/11/2023.
//

import UIKit
import AppTrackingTransparency

class IDIFAService: NSObject {
    private var tmpObject: Any?
    
    static let shared = IDIFAService()
    
    func requestTracking(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            if UIApplication.shared.applicationState == .active {
                ATTrackingManager.requestTrackingAuthorization { _ in
                    DispatchQueue.main.async { completion() }
                }
            }
            else {
                tmpObject = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { [weak self] _ in
                    
                    guard let self else { return }
                    
                    ATTrackingManager.requestTrackingAuthorization { _ in
                        DispatchQueue.main.async { completion() }
                    }
                    
                    self.tmpObject.flatMap {
                        NotificationCenter.default.removeObserver($0)
                    }
                })
            }
        }
        else {
            completion()
        }
    }
    
    var requestedIDFA: Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
        }
        else {
            return true
        }
    }
}
