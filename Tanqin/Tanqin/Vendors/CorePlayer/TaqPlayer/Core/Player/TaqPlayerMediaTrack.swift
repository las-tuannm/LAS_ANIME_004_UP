import Foundation
import AVFoundation

struct TaqPlayerMediaTrack {
    var option: AVMediaSelectionOption
    var group: AVMediaSelectionGroup
    var name: String
    var language: String
    
    func select(for player: TaqPlayer) {
        player.currentItem?.select(option, in: group)
    }
}
