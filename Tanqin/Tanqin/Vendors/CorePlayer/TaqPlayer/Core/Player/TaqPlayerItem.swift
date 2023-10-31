import AVFoundation

class TaqPlayerItem: AVPlayerItem {
    
    /// whether content passed through the asset is encrypted and should be decrypted
    var isEncrypted: Bool = false
    
    var audioTracks: [TaqPlayerMediaTrack] {
        return tracks(for: .audible)
    }
    
    var videoTracks: [TaqPlayerMediaTrack] {
        return tracks(for: .visual)
    }
    
    var captionTracks: [TaqPlayerMediaTrack] {
        return tracks(for: .legible)
    }
    
    deinit {
        
    }
    
    private func convert(with mediaSelectionOption: AVMediaSelectionOption, group: AVMediaSelectionGroup) -> TaqPlayerMediaTrack {
        let title = mediaSelectionOption.displayName
        let language = mediaSelectionOption.extendedLanguageTag ?? "none"
        return TaqPlayerMediaTrack(option: mediaSelectionOption, group: group, name: title, language: language)
    }
    
    private func tracks(for characteristic: AVMediaCharacteristic) -> [TaqPlayerMediaTrack] {
        guard let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) else {
            return []
        }
        let options = group.options
        let tracks = options.map { (option) -> TaqPlayerMediaTrack in
            return convert(with: option, group: group)
        }
        return tracks
    }
    
    func currentMediaTrack(for characteristic: AVMediaCharacteristic) -> TaqPlayerMediaTrack? {
        
        if let tracks = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic), let currentTrack = currentMediaSelection.selectedMediaOption(in: tracks) {
            return convert(with: currentTrack, group: tracks)
        }
        
        return nil
    }
    
}
