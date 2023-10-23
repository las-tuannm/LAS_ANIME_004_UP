//
//  AdmobBannerAdsAds.swift
//  Tanqin
//
//  Created by HaKT on 22/10/2023.
//

import UIKit
import GoogleMobileAds

enum AdmobBannerAdsPosition {
    case top
    case bottom
}

class AdmobBannerAds: NSObject {
    private var _bannerView: GADBannerView!
    private var _loadHandler: ((_ size: CGSize, _ success: Bool) -> Void)?
    
    init(loadHandler: ((_ size: CGSize, _ success: Bool) -> Void)?) {
        super.init()
        self._loadHandler = loadHandler
    }
    
    private func canShowAds() -> Bool {
        if !AdmobController.shared.isReady {
            return false
        }
        
        if GlobalDataModel.shared.admob_banner.isEmpty {
            return false
        }
        
        return true
    }
    
    private func getFullWidthAdaptiveAdSize(_ view: UIView) -> GADAdSize {
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.size.width)
    }
    
    func loadToView(parent: UIView,
                    controller: UIViewController,
                    backgroundColor: UIColor = .white,
                    position: AdmobBannerAdsPosition = .bottom,
                    padding: CGFloat = 0)
    {
        if !canShowAds() || _bannerView != nil {
            _loadHandler?(.zero, false)
            return
        }
        
        _bannerView = GADBannerView(adSize: getFullWidthAdaptiveAdSize(parent))
        _bannerView.translatesAutoresizingMaskIntoConstraints = false
        _bannerView.backgroundColor = backgroundColor
        _bannerView.adUnitID = GlobalDataModel.shared.admob_banner
        _bannerView.rootViewController = controller
        _bannerView.delegate = self
        _bannerView.load(GADRequest())
        parent.addSubview(_bannerView)
        
        switch position {
        case .top:
            parent.addConstraints(
                [NSLayoutConstraint(item: _bannerView as Any,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: parent.safeAreaLayoutGuide,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: padding),
                 NSLayoutConstraint(item: _bannerView as Any,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: parent,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
                ])
        case .bottom:
            parent.addConstraints(
                [NSLayoutConstraint(item: _bannerView as Any,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: parent.safeAreaLayoutGuide,
                                    attribute: .bottom,
                                    multiplier: 1,
                                    constant: -padding),
                 NSLayoutConstraint(item: _bannerView as Any,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: parent,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
                ])
        }
    }
    
    func removeFromSuperView() {
        if _bannerView != nil {
            _bannerView.removeFromSuperview()
        }
    }
}

extension AdmobBannerAds: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ _bannerView: GADBannerView) {
        if let handler = _loadHandler {
            handler(_bannerView.frame.size, true)
        }
    }
    
    func bannerView(_ _bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        removeFromSuperView()
        
        if let handler = _loadHandler {
            handler(.zero, false)
        }
    }
    
}
