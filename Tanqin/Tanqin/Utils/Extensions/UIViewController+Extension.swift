//
//  UIViewController+Extension.swift
//  Tanqin
//
//  Created by HaKT on 27/09/2023.
//

import Foundation
import UIKit
import Photos

extension UIViewController {
    
    func showAlert(title: String?, message: String, completion: (()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithActionCancel(title: String?, message: String, completion: (()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        // Create the activity indicator
        var activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray          // Fallback on earlier versions
        }
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the activity indicator to the view hierarchy
        view.addSubview(activityIndicator)
        
        // Add constraints to center the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Start animating the activity indicator
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator() {
        // Find the activity indicator view and remove it from the view hierarchy
        guard let activityIndicator = view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView else {
            return
        }
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
        activityIndicator.removeFromSuperview()
    }
    
//    func showIndicatorWithMessage(_ message: String) {
//        let indicatorView = IndicatorView(message: message)
//        indicatorView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(indicatorView)
//        view.isUserInteractionEnabled = false
//        NSLayoutConstraint.activate([
//            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    func hideIndicatorWithMessage() {
//        guard let activityIndicator = view.subviews.first(where: { $0 is IndicatorView }) as? IndicatorView else {
//            return
//        }
//        activityIndicator.stopAnimation()
//        activityIndicator.removeFromSuperview()
//        view.isUserInteractionEnabled = true
//    }
    
    func showAlertOpenSettingCamera() {
        self.showAlertSetting(title: "Kids Know World", message: "The app is currently denied access to the camera. Please open settings and grant camera access permission to enable image recognition from the camera.")
    }
    
    func showAlertOpenSettingPhotos() {
        self.showAlertSetting(title: "App", message: "The app is currently denied access to the photos. Please open settings and grant photos access permission to enable image recognition from the photos.")
    }
    
    func showAlertOpenSettingAudio() {
        self.showAlertSetting(title: "App", message: "The app is not authorized to access the microphone. Please grant microphone access permission to enable record audio.")
    }
    
    
    func showAlertSetting(title: String, message: String) {
        let changePrivacySetting = message
        let message = NSLocalizedString(changePrivacySetting, comment: message)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                style: .cancel,
                                                handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                style: .`default`,
                                                handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func requestPermissionAccessPhotos(completion: @escaping(Bool)->Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                completion(true)
            case .denied, .restricted:
                completion(false)
                print("Access to Photos library denied or restricted.")
            case .notDetermined:
                completion(false)
                print("Access to Photos library not determined.")
            case .limited:
                completion(false)
                print("Limit")
            @unknown default:
                completion(false)
                print("Unknown authorization status for Photos library.")
            }
        }
    }
    func addImpactFeedBack() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}
