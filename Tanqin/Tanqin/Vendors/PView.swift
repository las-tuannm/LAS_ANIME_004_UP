//
//  PView.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 31/10/2023.
//

import UIKit

@IBDesignable
class PView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerCircle: Bool = false {
        didSet {
            layer.cornerRadius = cornerCircle ? self.frame.size.height / 2 : 0
            layer.masksToBounds = cornerCircle
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorOpacity: CGFloat = 0 {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(colorOpacity)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 3)
    @IBInspectable var isShadow: Bool = false {
        didSet {
            if isShadow {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOpacity = 0.16
                self.layer.shadowRadius = 4.0
                self.layer.shadowOffset = shadowOffset
                //self.layer.shouldRasterize = true
            }
            setNeedsDisplay()
        }
    }
}







