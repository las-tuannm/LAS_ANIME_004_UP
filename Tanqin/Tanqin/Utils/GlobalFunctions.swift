//
//  GlobalFuntions.swift
//  Tanqin
//
//  Created by HaKT on 27/09/2023.
//

import Foundation
import UIKit

func asynAfter(_ time: Double, completion:@escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        completion()
    }
}

func openAppPageInAppStore(appID: String, forReview: Bool) {
    var urlStr = "https://itunes.apple.com/app/id\(appID)"
    
    if forReview == true {
        urlStr += "?action=write-review"
    }
    
    guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
    
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
    }
}

func getIOSVersion() -> String {
    return UIDevice.current.systemVersion
}

func getDeviceModelName() -> String {
    
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    
    return machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
}

func getAppVersion() -> String? {
    if let dictionary = Bundle.main.infoDictionary, let version = dictionary["CFBundleShortVersionString"] as? String {
        return version
    }
    return nil
}

func isLightColor(brightness: CGFloat, saturation: CGFloat) -> Bool {
    return 1 - brightness < 0.4 && saturation < 0.5
}

func isIpadScreen() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

func widthForLabel(text:String, font:UIFont, height:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.width
}

func heightForLabel(text:String, font:UIFont, width:CGFloat, numberLine: Int) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = numberLine
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}
