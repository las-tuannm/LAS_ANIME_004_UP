import Foundation

struct WebVTT {
    struct Cue {
        let timing: Timing
        let text: String
    }
    
    // Native timing in WebVTT. Measured in milliseconds.
    struct Timing {
        let start: Int
        let end: Int
    }
    
    let cues: [Cue]
    
    init(cues: [Cue]) {
        self.cues = cues
    }
}

extension WebVTT {
    func searchSubtitles(time: Int) -> String? {
        guard let firstSub = cues.filter({ c in
            return c.timing.start <= time && time <= c.timing.end
        }).first else {
            return nil
        }
        
        return firstSub.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension WebVTT.Timing {
    var duration: Int { return end - start }
}

// Converted times for convenience
extension WebVTT.Cue {
    var timeStart: TimeInterval { return TimeInterval(timing.start) / 1000 }
    var timeEnd: TimeInterval { return TimeInterval(timing.end) / 1000 }
    var duration: TimeInterval { return TimeInterval(timing.duration) / 1000 }
}
