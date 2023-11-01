import Foundation
import AVFoundation

protocol TaqPlayerPlaybackDelegate: AnyObject {
    
    /// Notifies when playback time changes
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    ///     - time: Current time
    func timeDidChange(player: TaqPlayer, to time: CMTime)
    
    /// Whether if playback should begin on specified player
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    ///
    /// - Returns: Boolean to validate if should play
    func playbackShouldBegin(player: TaqPlayer) -> Bool
    
    /// Whether if playback is skipping frames
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func playbackDidJump(player: TaqPlayer)
    
    /// Notifies when player will begin playback
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func playbackWillBegin(player: TaqPlayer)
    
    /// Notifies when playback is ready to play
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func playbackReady(player: TaqPlayer)
    
    /// Notifies when playback did begin
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func playbackDidBegin(player: TaqPlayer)
    
    /// Notifies when player ended playback
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func playbackDidEnd(player: TaqPlayer)
    
    /// Notifies when player starts buffering
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func startBuffering(player: TaqPlayer)
    
    /// Notifies when player ends buffering
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func endBuffering(player: TaqPlayer)
    
    /// Notifies when playback fails with an error
    ///
    /// - Parameters:
    ///     - error: playback error
    func playbackDidFailed(with error: TaqPlayerError)
    
    /// Notifies when player will pause playback
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func playbackWillPause(player: TaqPlayer)
    
    /// Notifies when player did pause playback
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    func playbackDidPause(player: TaqPlayer)
    
    /// Notifies when current TaqPlayerItem is ready to play
    ///
    /// - Parameters:
    ///     - player: TaqPlayer being used
    ///     - item: TaqPlayerItem being used
    func playbackItemReady(player: TaqPlayer, item: TaqPlayerItem?)
    
}

extension TaqPlayerPlaybackDelegate {
    
    func timeDidChange(player: TaqPlayer, to time: CMTime) { }
    
    func playbackShouldBegin(player: TaqPlayer) -> Bool {
        return true
    }
    
    func playbackDidJump(player: TaqPlayer) { }
    
    func playbackWillBegin(player: TaqPlayer) { }
    
    func playbackReady(player: TaqPlayer) { }
    
    func playbackDidBegin(player: TaqPlayer) { }
    
    func playbackDidEnd(player: TaqPlayer) { }
    
    func startBuffering(player: TaqPlayer) { }
    
    func endBuffering(player: TaqPlayer) { }
    
    func playbackDidFailed(with error: TaqPlayerError) { }
    
    func playbackWillPause(player: TaqPlayer) { }
    
    func playbackDidPause(player: TaqPlayer) { }
    
    func playbackItemReady(player: TaqPlayer, item: TaqPlayerItem?) { }
    
}
