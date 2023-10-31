import UIKit
import CoreMedia
import AVFoundation
import AVKit

class TaqPlayerView: UIView {
    
    deinit {
        player.replaceCurrentItem(with: nil)
    }
    
    /// AVPlayer used in TaqPlayer implementation
    var player: TaqPlayer!
    
    /// TaqPlayerControls instance being used to display controls
    var controls: TaqPlayerControls? = nil
    
    /// TaqPlayerLayerView instance
    var renderingView: TaqPlayerLayerView!
    
    /// TaqPlayerPlaybackDelegate instance
    weak var playbackDelegate: TaqPlayerPlaybackDelegate? = nil
    
    /// TaqPlayer initial container
    private weak var nonFullscreenContainer: UIView!
    
    /// Whether player is prepared
    var ready: Bool = false
    
    /// Whether it should autoplay when adding a VPlayerItem
    var autoplay: Bool = true
    
    /// Whether Player is currently playing
    var isPlaying: Bool = false
    
    /// Whether Player is seeking time
    var isSeeking: Bool = false
    
    /// Whether Player is presented in Fullscreen
    var isFullscreenModeEnabled: Bool = false
    
    /// Whether PIP Mode is enabled via pipController
    var isPipModeEnabled: Bool = false
    
    /// Whether Player is Fast Forwarding
    var isForwarding: Bool {
        return player.rate > 1.0
    }
    
    /// Whether Player is Rewinding
    var isRewinding: Bool {
        return player.rate < 0.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    /// TaqPlayerControls instance to display controls in player, using TaqPlayerGestureRecieverView instance
    /// to handle gestures
    ///
    /// - Parameters:
    ///     - controls: TaqPlayerControls instance used to display controls
    ///     - gestureReciever: Optional gesture reciever view to be used to receive gestures
    func use(controls: TaqPlayerControls, with gestureReciever: TaqPlayerGestureRecieverView? = nil) {
        self.controls = controls
        let coordinator = TaqPlayerControlsCoordinator()
        coordinator.player = self
        coordinator.controls = controls
        coordinator.gestureReciever = gestureReciever
        controls.controlsCoordinator = coordinator
        
        addSubview(coordinator)
        bringSubviewToFront(coordinator)
    }
    
    /// Update controls to specified time
    ///
    /// - Parameters:
    ///     - time: Time to be updated to
    func updateControls(toTime time: CMTime) {
        controls?.timeDidChange(toTime: time)
    }
    
    /// Prepares the player to play
    func prepare() {
        ready = true
        player = TaqPlayer()
        player.handler = self
        player.preparePlayerPlaybackDelegate()
        renderingView = TaqPlayerLayerView(with: self)
        layout(view: renderingView, into: self)
    }
    
    /// Layout a view within another view stretching to edges
    ///
    /// - Parameters:
    ///     - view: The view to layout.
    ///     - into: The container view.
    func layout(view: UIView, into: UIView? = nil) {
        guard let into = into else {
            return
        }
        into.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: into.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: into.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: into.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: into.bottomAnchor).isActive = true
    }
    
    /// Enables or disables fullscreen
    ///
    /// - Parameters:
    ///     - enabled: Whether or not to enable
    func setFullscreen(enabled: Bool) {
        if enabled == isFullscreenModeEnabled {
            return
        }
        if enabled {
            if let window = ApplicationHelper.shared.window() {
                nonFullscreenContainer = superview
                removeFromSuperview()
                layout(view: self, into: window)
            }
        } else {
            removeFromSuperview()
            layout(view: self, into: nonFullscreenContainer)
        }
        
        isFullscreenModeEnabled = enabled
    }
    
    /// Sets the item to be played
    ///
    /// - Parameters:
    ///     - item: The VPlayerItem instance to add to player.
    func set(item: TaqPlayerItem?) {
        if !ready {
            prepare()
        }
        
        player.replaceCurrentItem(with: item)
        if autoplay && item?.error == nil {
            play()
        }
    }
    
    /// Play
    @IBAction func play(sender: Any? = nil) {
        if playbackDelegate?.playbackShouldBegin(player: player) ?? true {
            player.play()
            controls?.playPauseButton?.set(active: true)
            isPlaying = true
        }
    }
    
    /// Pause
    @IBAction func pause(sender: Any? = nil) {
        player.pause()
        controls?.playPauseButton?.set(active: false)
        isPlaying = false
    }
    
    /// Toggle Playback
    @IBAction func togglePlayback(sender: Any? = nil) {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    static func makeItem(url: URL, headers: [String: String]) -> TaqPlayerItem {
#if DEBUG
        print("headers---\n\(headers)")
#endif
        
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        let item = TaqPlayerItem(asset: asset)
        return item
    }
}
