import UIKit
import CoreMedia
import AVFoundation

class TaqPlayerControlsCoordinator: UIView, TaqPlayerGestureRecieverViewDelegate {
    
    /// TaqPlayer instance being used
    weak var player: TaqPlayerView!
    
    /// TaqPlayerControls instance being used
    weak var controls: TaqPlayerControls!
    
    /// TaqPlayerGestureRecieverView instance being used
    var gestureReciever: TaqPlayerGestureRecieverView!
    
    deinit {
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stretchToEdges()
    }
    
    func configureView() {
        if controls != nil {
            addSubview(controls)
        }
        if gestureReciever == nil {
            gestureReciever = TaqPlayerGestureRecieverView()
            gestureReciever.delegate = self
            addSubview(gestureReciever)
            sendSubviewToBack(gestureReciever)
        }
        stretchToEdges()
    }
    
    func stretchToEdges() {
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
    
    func hideBannerIfNeed() {
        
    }
    
    func showBannerIfNeed() {
        
    }
    
    /// Notifies when pinch was recognized
    ///
    /// - Parameters:
    ///     - scale: CGFloat value
    func didPinch(with scale: CGFloat) {
        
    }
    
    /// Notifies when tap was recognized
    ///
    /// - Parameters:
    ///     - point: CGPoint at which tap was recognized
    func didTap(at point: CGPoint) {
        if controls.behaviour.showingControls {
            controls.behaviour.hide()
            //showBannerIfNeed()
            
        } else {
            controls.behaviour.show()
            //hideBannerIfNeed()
        }
    }
    
    /// Notifies when tap was recognized
    ///
    /// - Parameters:
    ///     - point: CGPoint at which tap was recognized
    func didDoubleTap(at point: CGPoint) {
        
    }
    
    /// Notifies when pan was recognized
    ///
    /// - Parameters:
    ///     - translation: translation of pan in CGPoint representation
    ///     - at: initial point recognized
    func didPan(with translation: CGPoint, initially at: CGPoint) {
        
    }
    
}
