import AVFoundation

class TaqPlayer: AVPlayer {
    
    /// Dispatch queue for resource loader
    private let queue = DispatchQueue(label: "com.nit.TaqPlayer")
    
    /// Notification key to extract info
    enum ZPlayerNotificationInfoKey: String {
        case time = "ANI_PLAYER_TIME"
    }
    
    /// Notification name to post
    enum ZPlayerNotificationName: String {
        case assetLoaded = "ANI_ASSET_ADDED"
        case timeChanged = "ANI_TIME_CHANGED"
        case willPlay = "ANI_PLAYER_STATE_WILL_PLAY"
        case play = "ANI_PLAYER_STATE_PLAY"
        case pause = "ANI_PLAYER_STATE_PAUSE"
        case buffering = "ANI_PLAYER_BUFFERING"
        case endBuffering = "ANI_PLAYER_END_BUFFERING"
        case didEnd = "ANI_PLAYER_END_PLAYING"
        
        /// Notification name representation
        var notification: NSNotification.Name {
            return NSNotification.Name.init(self.rawValue)
        }
    }
    
    /// TaqPlayer instance
    weak var handler: TaqPlayerView!
    
    /// Whether player is buffering
    var isBuffering: Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVPlayerItem.timeJumpedNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self)
        removeObserver(self, forKeyPath: "status")
    }
    
    /// Play content
    override func play() {
        handler.playbackDelegate?.playbackWillBegin(player: self)
        NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.willPlay.notification, object: self, userInfo: nil)
        if !(handler.playbackDelegate?.playbackShouldBegin(player: self) ?? true) {
            return
        }
        NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.play.notification, object: self, userInfo: nil)
        super.play()
        handler.playbackDelegate?.playbackDidBegin(player: self)
    }
    
    /// Pause content
    override func pause() {
        handler.playbackDelegate?.playbackWillPause(player: self)
        NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.pause.notification, object: self, userInfo: nil)
        super.pause()
        handler.playbackDelegate?.playbackDidPause(player: self)
    }
    
    /// Replace current item with a new one
    ///
    /// - Parameters:
    ///     - item: AVPlayer item instance to be added
    override func replaceCurrentItem(with item: AVPlayerItem?) {
        if currentItem != nil {
            currentItem!.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            currentItem!.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            currentItem!.removeObserver(self, forKeyPath: "playbackBufferFull")
            currentItem!.removeObserver(self, forKeyPath: "status")
        }
        
        super.replaceCurrentItem(with: item)
        
        NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.assetLoaded.notification, object: self, userInfo: nil)
        if let newItem = currentItem ?? item {
            newItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            newItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
            newItem.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
            newItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        }
    }
    
}

extension TaqPlayer {
    
    /// Start time
    ///
    /// - Returns: Player's current item start time as CMTime
    func startTime() -> CMTime {
        guard let item = currentItem else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
        
        if item.reversePlaybackEndTime.isValid {
            return item.reversePlaybackEndTime
        } else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
    }
    
    /// End time
    ///
    /// - Returns: Player's current item end time as CMTime
    func endTime() -> CMTime {
        guard let item = currentItem else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
        
        if item.forwardPlaybackEndTime.isValid {
            return item.forwardPlaybackEndTime
        } else {
            if item.duration.isValid && !item.duration.isIndefinite {
                return item.duration
            } else {
                return item.currentTime()
            }
        }
    }
    @objc private func playerDidEnd(_ notification:Notification){
        
        if let item = notification.object as? AVPlayerItem, item == self.currentItem{
            NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.didEnd.notification, object: self, userInfo: nil)
            self.handler?.playbackDelegate?.playbackDidEnd(player: self)
        }
    }
    /// Prepare players playback delegate observers
    func preparePlayerPlaybackDelegate() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.currentItem)
        NotificationCenter.default.addObserver(forName: AVPlayerItem.timeJumpedNotification, object: self, queue: OperationQueue.main) { [weak self] (notification) in
            guard let self = self else { return }
            self.handler?.playbackDelegate?.playbackDidJump(player: self)
        }
        addPeriodicTimeObserver(
            forInterval: CMTime(
                seconds: 1,
                preferredTimescale: CMTimeScale(NSEC_PER_SEC)
            ),
            queue: DispatchQueue.main) { [weak self] (time) in
                guard let self = self else { return }
                NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.timeChanged.notification, object: self, userInfo: [ZPlayerNotificationInfoKey.time.rawValue: time])
                self.handler?.playbackDelegate?.timeDidChange(player: self, to: time)
            }
        
        addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    /// Value observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let handler = handler else {
            return
        }
        
        if let obj = object as? TaqPlayer, obj == self {
            if keyPath == "status" {
                switch status {
                case AVPlayer.Status.readyToPlay:
                    NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.timeChanged.notification, object: self, userInfo: [ZPlayerNotificationInfoKey.time.rawValue: CMTime.zero])
                    handler.playbackDelegate?.playbackReady(player: self)
                    
                case AVPlayer.Status.failed:
                    handler.playbackDelegate?.playbackDidFailed(with: TaqPlayerError.unknown)
                    
                default:
                    break;
                }
            }
        }
        else {
            switch keyPath ?? "" {
            case "status":
                if let value = change?[.newKey] as? Int, let status = AVPlayerItem.Status(rawValue: value), let item = object as? AVPlayerItem {
                    if status == .failed, let error = item.error as NSError?, let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                        let playbackError: TaqPlayerError
                        switch underlyingError.code {
                        case -12937:
                            playbackError = .authenticationError
                        case -16840:
                            playbackError = .unauthorized
                        case -12660:
                            playbackError = .forbidden
                        case -12938:
                            playbackError = .notFound
                        case -12661:
                            playbackError = .unavailable
                        case -12645, -12889:
                            playbackError = .mediaFileError
                        case -12318:
                            playbackError = .bandwidthExceeded
                        case -12642:
                            playbackError = .playlistUnchanged
                        case -12911:
                            playbackError = .decoderMalfunction
                        case -12913:
                            playbackError = .decoderTemporarilyUnavailable
                        case -1004:
                            playbackError = .wrongHostIP
                        case -1003:
                            playbackError = .wrongHostDNS
                        case -1000:
                            playbackError = .badURL
                        case -1202:
                            playbackError = .invalidRequest
                        case -16847:
                            playbackError = .internalServerError
                        default:
                            playbackError = .unknown
                        }
                        handler.playbackDelegate?.playbackDidFailed(with: playbackError)
                    }
                    
                    if status == .readyToPlay, let currentItem = self.currentItem as? TaqPlayerItem {
                        handler.playbackDelegate?.playbackItemReady(player: self, item: currentItem)
                    }
                }
                
            case "playbackBufferEmpty":
                isBuffering = true
                NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.buffering.notification, object: self, userInfo: nil)
                handler.playbackDelegate?.startBuffering(player: self)
                
            case "playbackLikelyToKeepUp":
                isBuffering = false
                NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.endBuffering.notification, object: self, userInfo: nil)
                handler.playbackDelegate?.endBuffering(player: self)
                guard  let item = self.currentItem as? TaqPlayerItem else { return  }
                NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.timeChanged.notification, object: self, userInfo: [ZPlayerNotificationInfoKey.time.rawValue: item.currentTime()])
                
            case "playbackBufferFull":
                isBuffering = false
                NotificationCenter.default.post(name: TaqPlayer.ZPlayerNotificationName.endBuffering.notification, object: self, userInfo: nil)
                handler.playbackDelegate?.endBuffering(player: self)
                
            default:
                break;
            }
        }
    }
    
}
