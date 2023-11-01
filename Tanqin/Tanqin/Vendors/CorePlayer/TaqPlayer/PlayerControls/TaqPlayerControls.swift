import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import SDWebImage

class TaqPlayerControls: UIView {
    private (set) var isLocking: Bool = false {
        didSet {
            let views: [Any] = [
                backButton, titleLabel, listButton, lockButton,
                skipBackwardButton, skipForwardButton, playPauseButton,
                currentTimeLabel, totalTimeLabel, seekbarSlider,
                subtitleButton, airplayContainer, seasonButton,
                resizeButton, speedButton
            ]
            
            lockView?.isHidden = !isLocking
            views.forEach { item in
                if let tmp = item as? UIView {
                    tmp.isHidden = isLocking
                }
            }
        }
    }
    
    /// TaqPlayer intance being controlled
    weak var handler: TaqPlayerView!
    
    /// TaqPlayerControlsBehaviour being used to validate ui
    var behaviour: TaqPlayerControlsBehaviour!
    
    var airplayButton: MPVolumeView? = nil
    
    var onBack: (() -> Void)? = nil
    var onSubtitle: (() -> Void)? = nil
    var onList: (() -> Void)? = nil
    var onSeason: (() -> Void)? = nil
    var onResize: (() -> Void)? = nil
    var onSpeed: (() -> Void)? = nil
    
    /// TaqPlayerControlsCoordinator instance
    weak var controlsCoordinator: TaqPlayerControlsCoordinator!
    
    @IBOutlet weak var backButton: UIButton? = nil
    
    @IBOutlet weak var titleLabel: UILabel? = nil
    
    @IBOutlet weak var lockButton: UIButton? = nil
    
    @IBOutlet weak var subtitleButton: UIButton? = nil
    
    @IBOutlet weak var listButton: UIButton? = nil
    
    @IBOutlet weak var seasonButton: UIButton? = nil
    
    @IBOutlet weak var resizeButton: UIButton? = nil
    
    @IBOutlet weak var speedButton: UIButton? = nil
    
    @IBOutlet weak var lockView: UIView? = nil
    
    /// UIButton instance to represent the play/pause button
    @IBOutlet weak var playPauseButton: UIButton? = nil
    
    /// UIViewContainer to implement the airplay button
    @IBOutlet weak var airplayContainer: UIView? = nil
    
    /// UIButton instance to represent the skip forward button
    @IBOutlet weak var skipForwardButton: UIButton? = nil
    
    /// UIButton instance to represent the skip backward button
    @IBOutlet weak var skipBackwardButton: UIButton? = nil
    
    /// UISlider instance to represent the seekbar slider
    @IBOutlet weak var seekbarSlider: UISlider? = nil
    
    /// UILabel instance to represent the current time label
    @IBOutlet weak var currentTimeLabel: UILabel? = nil
    
    /// UILabel instance to represent the total time label
    @IBOutlet weak var totalTimeLabel: UILabel? = nil
    
    /// UIView to be shown when buffering
    @IBOutlet weak var bufferingView: UIView? = nil
    
    private var wasPlayingBeforeRewinding: Bool = false
    private var wasPlayingBeforeForwarding: Bool = false
    private var wasPlayingBeforeSeeking: Bool = false
    
    /// Skip size in seconds to be used for skipping forward or backwards
    var skipSize: Double = 10
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: TaqPlayer.ZPlayerNotificationName.timeChanged.notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: TaqPlayer.ZPlayerNotificationName.play.notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: TaqPlayer.ZPlayerNotificationName.pause.notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: TaqPlayer.ZPlayerNotificationName.buffering.notification, object: nil)
        NotificationCenter.default.removeObserver(self, name: TaqPlayer.ZPlayerNotificationName.endBuffering.notification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        behaviour.hide()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutInSuperview()
    }
    
    func layoutInSuperview() {
        if let h = superview as? TaqPlayerControlsCoordinator {
            handler = h.player
            if behaviour == nil {
                behaviour = TaqPlayerControlsBehaviour(with: self)
            }
            prepare()
        }
    }
    
    /// Notifies when time changes
    ///
    /// - Parameters:
    ///     - time: CMTime representation of the current playback time
    func timeDidChange(toTime time: CMTime) {
        currentTimeLabel?.update(toTime: time.seconds)
        totalTimeLabel?.update(toTime: handler.player.endTime().seconds)
        setSeekbarSlider(start: handler.player.startTime().seconds, end: handler.player.endTime().seconds, at: time.seconds)
        
        if !(handler.isSeeking || handler.isRewinding || handler.isForwarding) {
            behaviour.update(with: time.seconds)
        }
    }
    
    func setSeekbarSlider(start startValue: Double, end endValue: Double, at time: Double) {
        let time = time.isNaN ? 0 : time
        let startValue = startValue.isNaN ? 0 : startValue
        let endValue = endValue.isNaN ? 0 : endValue
        
        seekbarSlider?.minimumValue = Float(startValue)
        seekbarSlider?.maximumValue = Float(endValue)
        seekbarSlider?.value = Float(time)
    }
    
    /// Remove coordinator from player
    func removeFromPlayer() {
        controlsCoordinator.removeFromSuperview()
    }
    
    /// Prepare controls targets and notification listeners
    func prepare() {
        stretchToEdges()
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        lockView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unlockScreen)))
        
        backButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        titleLabel?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        listButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        
        speedButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        resizeButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        lockButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        seasonButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        subtitleButton?.addShadow(color: .black, offsetSize: .init(width: 3, height: 3), radius: 3, opacity: 1)
        
        backButton?.addTarget(self, action: #selector(back), for: .touchUpInside)
        lockButton?.addTarget(self, action: #selector(lockScreen), for: .touchUpInside)
        subtitleButton?.addTarget(self, action: #selector(subtitle), for: .touchUpInside)
        seasonButton?.addTarget(self, action: #selector(listSeason), for: .touchUpInside)
        resizeButton?.addTarget(self, action: #selector(resizeHandle), for: .touchUpInside)
        speedButton?.addTarget(self, action: #selector(speedHandle), for: .touchUpInside)
        listButton?.addTarget(self, action: #selector(listChoose), for: .touchUpInside)
        playPauseButton?.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        
        skipForwardButton?.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
        skipBackwardButton?.addTarget(self, action: #selector(skipBackward), for: .touchUpInside)
        
        prepareSeekbar()
        
        airplayButton = MPVolumeView()
        airplayButton?.showsVolumeSlider = false
        airplayContainer?.addSubview(airplayButton!)
        airplayContainer?.clipsToBounds = false
        airplayButton?.frame = airplayContainer?.bounds ?? CGRect.zero
        
        for view in airplayButton?.subviews ?? [] {
            if view is UIButton {
                (view as! UIButton).setImage(UIImage.getImage("ic-airplay"), for: .normal)
                (view as! UIButton).bounds = .init(x: 0, y: 0, width: 25, height: 25)
            }
        }
        
        let image = UIImage.getImage("slider-thumb")?.sd_tintedImage(with: UIColor.init(rgb: 0xBB52FF))
        seekbarSlider?.setThumbImage(image, for: .normal)
        seekbarSlider?.addTarget(self, action: #selector(playheadChanged(with:)), for: .valueChanged)
        seekbarSlider?.addTarget(self, action: #selector(seekingEnd), for: .touchUpInside)
        seekbarSlider?.addTarget(self, action: #selector(seekingEnd), for: .touchUpOutside)
        seekbarSlider?.addTarget(self, action: #selector(seekingStart), for: .touchDown)
        
        prepareNotificationListener()
        
        isLocking = false
        playPauseButton?.isHidden = true    // default hidden this button to display indicator view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    /// Detect the notfication listener
    private func checkOwnershipOf(object: Any?, completion: @autoclosure ()->()?) {
        guard let ownerPlayer = object as? TaqPlayer else { return }
        if ownerPlayer.isEqual(handler?.player) {
            completion()
        }
    }
    
    /// Prepares the notification observers/listeners
    func prepareNotificationListener() {
        NotificationCenter.default.addObserver(forName: TaqPlayer.ZPlayerNotificationName.timeChanged.notification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            guard let self = self else { return }
            if let time = notification.userInfo?[TaqPlayer.ZPlayerNotificationInfoKey.time.rawValue] as? CMTime {
                self.checkOwnershipOf(object: notification.object, completion: self.timeDidChange(toTime: time))
            }
        }
        NotificationCenter.default.addObserver(forName: TaqPlayer.ZPlayerNotificationName.didEnd.notification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.playPauseButton?.set(active: false))
        }
        NotificationCenter.default.addObserver(forName: TaqPlayer.ZPlayerNotificationName.play.notification, object: nil, queue: OperationQueue.main) { [weak self]  (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.playPauseButton?.set(active: true))
        }
        NotificationCenter.default.addObserver(forName: TaqPlayer.ZPlayerNotificationName.pause.notification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.playPauseButton?.set(active: false))
        }
        NotificationCenter.default.addObserver(forName: TaqPlayer.ZPlayerNotificationName.endBuffering.notification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.hideBuffering())
        }
        NotificationCenter.default.addObserver(forName: TaqPlayer.ZPlayerNotificationName.buffering.notification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let self = self else { return }
            self.checkOwnershipOf(object: notification.object, completion: self.showBuffering())
        }
    }
    
    /// Prepare the seekbar values
    func prepareSeekbar() {
        setSeekbarSlider(start: handler.player.startTime().seconds, end: handler.player.endTime().seconds, at: handler.player.currentTime().seconds)
    }
    
    /// Show buffering view
    func showBuffering() {
        bufferingView?.isHidden = false
        if !isLocking {
            playPauseButton?.isHidden = true
        }
    }
    
    /// Hide buffering view
    func hideBuffering() {
        bufferingView?.isHidden = true
        if !isLocking {
            playPauseButton?.isHidden = false
        }
    }
    
    @objc func unlockScreen() {
        isLocking = false
        behaviour.show()
    }
    
    @IBAction func back(sender: Any? = nil) {
        onBack?()
    }
    
    @IBAction func lockScreen(sender: Any? = nil) {
        isLocking = true
        behaviour.show()
    }
    
    @IBAction func subtitle(sender: Any? = nil) {
        behaviour.hide()
        onSubtitle?()
    }
    
    @IBAction func listSeason(sender: Any? = nil) {
        behaviour.hide()
        onSeason?()
    }
    
    @IBAction func resizeHandle(sender: Any? = nil) {
        behaviour.show()
        onResize?()
    }
    
    @IBAction func speedHandle(sender: Any? = nil) {
        behaviour.hide()
        onSpeed?()
    }
    
    @IBAction func listChoose(sender: Any? = nil) {
        behaviour.hide()
        onList?()
    }
    
    /// Skip forward (n) seconds in time
    @IBAction func skipForward(sender: Any? = nil) {
        let time = handler.player.currentTime() + CMTime(seconds: skipSize, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.player.seek(to: time)
    }
    
    /// Skip backward (n) seconds in time
    @IBAction func skipBackward(sender: Any? = nil) {
        let time = handler.player.currentTime() - CMTime(seconds: skipSize, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.player.seek(to: time)
    }
    
    /// End seeking
    @IBAction func seekingEnd(sender: Any? = nil) {
        handler.isSeeking = false
        let value = Double(seekbarSlider!.value)
        let time = CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.player.seek(to: time)
        behaviour.update(with: time.seconds)
        
        if wasPlayingBeforeSeeking {
            handler.play()
        }
    }
    
    /// Start Seeking
    @IBAction func seekingStart(sender: Any? = nil) {
        wasPlayingBeforeSeeking = handler.isPlaying
        handler.isSeeking = true
        handler.pause()
    }
    
    /// Playhead changed in UISlider
    ///
    /// - Parameters:
    ///     - sender: UISlider that updated
    @IBAction func playheadChanged(with sender: UISlider) {
        handler.isSeeking = true
        let value = Double(sender.value)
        let time = CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        currentTimeLabel?.update(toTime: time.seconds)
    }
    
    /// Toggle fullscreen mode
    @IBAction func toggleFullscreen(sender: Any? = nil) {
        handler.setFullscreen(enabled: !handler.isFullscreenModeEnabled)
    }
    
    /// Toggle playback
    @IBAction func togglePlayback(sender: Any? = nil) {
        if handler.isRewinding || handler.isForwarding {
            handler.player.rate = 1
            playPauseButton?.set(active: true)
            return;
        }
        if handler.isPlaying {
            playPauseButton?.set(active: false)
            handler.pause()
        } else {
            if handler.playbackDelegate?.playbackShouldBegin(player: handler.player) ?? true {
                playPauseButton?.set(active: true)
                handler.play()
            }
        }
    }
    
    private func preparePlaybackButton() {
        if handler.isPlaying {
            playPauseButton?.set(active: true )
        } else {
            playPauseButton?.set(active: false)
        }
    }
    
}
