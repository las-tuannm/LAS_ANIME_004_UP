import UIKit

class BaseInterstitial: NSObject {
    
    var isReady: Bool {
        return false
    }
    
    var canShowAds: Bool {
        return false
    }
    
    func preloadAd(completion: @escaping (_ success: Bool) -> Void) {
        
    }
    
    func tryToPresent(with closeHandler: @escaping () -> Void) {
        
    }
}
