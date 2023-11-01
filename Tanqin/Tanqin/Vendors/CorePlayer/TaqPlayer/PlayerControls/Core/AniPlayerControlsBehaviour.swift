import UIKit
import Foundation

class TaqPlayerControlsBehaviour {
    
    /// TaqPlayerControls instance being controlled
    weak var controls: TaqPlayerControls!
    
    /// Whether controls are bieng displayed
    var showingControls: Bool = true
    
    /// Whether controls should be hidden when showingControls is true
    var shouldHideControls: Bool = true
    
    /// Whether controls should be shown when showingControls is false
    var shouldShowControls: Bool = true
    
    var shouldAutohide: Bool = false
    
    /// Elapsed time between controls being shown and current time
    var elapsedTime: TimeInterval = 0
    
    /// Last time when controls were shown
    var activationTime: TimeInterval = 0
    
    /// At which TimeInterval controls hide automatically
    var deactivationTimeInterval: TimeInterval = 3
    
    /// Custom deactivation block
    var deactivationBlock: ((TaqPlayerControls) -> Void)? = nil
    
    /// Custom activation block
    var activationBlock: ((TaqPlayerControls) -> Void)? = nil
    
    deinit {
        
    }
    
    /// Constructor
    ///
    /// - Parameters:
    ///     - controls: TaqPlayerControls to be controlled.
    init(with controls: TaqPlayerControls) {
        self.controls = controls
    }
    
    /// Update ui based on time
    ///
    /// - Parameters:
    ///     - time: TimeInterval to check whether to update controls.
    func update(with time: TimeInterval) {
        elapsedTime = time
        if showingControls && shouldHideControls && !controls.handler.player.isBuffering && !controls.handler.isSeeking && controls.handler.isPlaying {
            let timediff = elapsedTime - activationTime
            if timediff >= deactivationTimeInterval {
                hide()
            }
        }
    }
    
    /// Default activation block
    func defaultActivationBlock() {
        controls.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.controls.alpha = 1
        }
    }
    
    /// Default deactivation block
    func defaultDeactivationBlock() {
        UIView.animate(withDuration: 0.3, animations: {
            self.controls.alpha = 0
        }) {
            if $0 {
                self.controls.isHidden = true
            }
        }
    }
    
    /// Hide the controls
    func hide() {
        if shouldAutohide {
            if deactivationBlock != nil {
                deactivationBlock!(controls)
            } else {
                defaultDeactivationBlock()
            }
            showingControls = false
        }
        
    }
    
    /// Show the controls
    func show() {
        if shouldAutohide {
            if !shouldShowControls {
                return
            }
            activationTime = elapsedTime
            if activationBlock != nil {
                activationBlock!(controls)
            } else {
                defaultActivationBlock()
            }
            showingControls = true
        }
    }
    
}
