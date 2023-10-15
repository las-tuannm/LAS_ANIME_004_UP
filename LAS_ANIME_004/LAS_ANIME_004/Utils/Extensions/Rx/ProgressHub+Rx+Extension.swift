//
//  ProgressHub+Rx+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//
//
import Foundation
import RxSwift
import RxCocoa


import UIKit

class ActivityIndicatorUtility {
    static var activityIndicator: UIActivityIndicatorView?
    
    static func show() {
        DispatchQueue.main.async {
            if activityIndicator == nil {
                if #available(iOS 13.0, *) {
                    activityIndicator = UIActivityIndicatorView(style: .large)
                } else {
                    activityIndicator = UIActivityIndicatorView()
                    activityIndicator?.style = .gray
                    // Fallback on earlier versions
                }
                activityIndicator?.color = .gray
                activityIndicator?.center = UIApplication.shared.keyWindow?.center ?? CGPoint.zero
                activityIndicator?.hidesWhenStopped = true
                
            }
//            guard let vc = ActivityIndicatorUtility.getTopMostViewController() else {
//                return
//            }
//            vc.view.addSubview(activityIndicator!)
            UIApplication.shared.keyWindow?.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    
    static func getTopMostViewController() -> UIViewController? {
            var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

            while let presentedViewController = topMostViewController?.presentedViewController {
                topMostViewController = presentedViewController
            }

            return topMostViewController
        }

    static func hide() {
        DispatchQueue.main.async {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
        }
    }
    
    public var rx_progresshud_animating: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()

            switch (event) {
            case .next(let value):
                if value {
                    ActivityIndicatorUtility.show()
                } else {
                    ActivityIndicatorUtility.hide()
                }
            case .error( _):
                ActivityIndicatorUtility.hide()
            case .completed:
                ActivityIndicatorUtility.hide()
            }
        }
    }
}
