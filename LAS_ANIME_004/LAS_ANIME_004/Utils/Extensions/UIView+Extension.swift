//
//  UIView+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit

extension UIView {
    
    class var nibNameClass: String { return String(describing: self.self) }
    
    class var nibClass: UINib? {
        if Bundle.main.path(forResource: nibNameClass, ofType: "nib") != nil {
            return UINib(nibName: nibNameClass, bundle: nil)
        } else {
            return nil
        }
    }
    
    class func loadFromNib(nibName: String? = nil) -> Self? {
        return loadFromNib(nibName: nibName, type: self)
    }
    
    class func loadFromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T? {
        guard let nibViews = Bundle.main.loadNibNamed(nibName ?? self.nibNameClass, owner: nil, options: nil)
        else { return nil }
        
        return nibViews.filter({ (nibItem) -> Bool in
            return (nibItem as? T) != nil
        }).first as? T
    }
    
    // Set Radius
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func setCornerTopRadius(radius: CGFloat, borderwidth: CGFloat, borderColor: UIColor) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderwidth
        layer.masksToBounds = true
    }
    
    func setSpecificCornerRadius(corner: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corner
    }
    
    // Set Border
    func setBorder(width: CGFloat, color: UIColor?) {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
    }
    
    // Set radius with border
    func setLayout(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor?) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
    }
    
    // Set Shadow
    func setShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float) {
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    func removeAllSubviews() {
        let allSubs = self.subviews
        for aSub in allSubs {
            aSub.removeFromSuperview()
        }
    }
}
