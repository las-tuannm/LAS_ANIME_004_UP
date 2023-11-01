import UIKit
import Foundation

protocol TaqPlayerGestureRecieverViewDelegate: AnyObject {
    
    /// Pinch was recognized
    ///
    /// - Parameters:
    ///     - scale: CGFloat scale
    func didPinch(with scale: CGFloat)
    
    /// Tap was recognized
    ///
    /// - Parameters:
    ///     - point: CGPoint at wich touch was recognized
    func didTap(at point: CGPoint)
    
    /// Double tap was recognized
    ///
    /// - Parameters:
    ///     - point: CGPoint at wich touch was recognized
    func didDoubleTap(at point: CGPoint)
    
    /// Pan was recognized
    ///
    /// - Parameters:
    ///     - translation: translation in view
    ///     - at: initial point recognized
    func didPan(with translation: CGPoint, initially at: CGPoint)
    
}
