import Foundation

internal struct VideoIntentModel {
    let sources: [FileSVModel]
    let tracks: [SubtitleModel]
}

internal enum SourceType {
    case sub, softsub, dub
}

internal struct FileSVModel: Equatable {
    let file: String
    let pixelsize: String
    let title: String
    let name: String
    let type: SourceType
    let headers: [String: String]
    
    public static func createInstance(_ d: TaqiDictionary) -> FileSVModel {
        let file = d["file"] as? String
        let pixelsize = d["pixelsize"] as? String
        let title = d["title"] as? String
        let name = d["extractor"] as? String
        let tmp = (d["type"] as? String) ?? title
        let headers = (d["headers"] as? [String: String]) ?? [:]
        var type: SourceType = .sub
        
        switch (tmp ?? "").lowercased() {
        case let x where x.contains("softsub"):
            type = .softsub
        case let x where x.contains("dub"):
            type = .dub
        default: break
        }
        
        return FileSVModel(file: file ?? "", pixelsize: pixelsize ?? "", title: title ?? "",
                           name: name ?? "", type: type, headers: headers)
    }
}

internal enum SubSource {
    case original
    case opensubtitle
    case subscene
}

internal struct SubtitleModel {
    let file: String
    let label: String
    let source: SubSource
    
    enum Format {
        case vtt
        case srt
    }
    
    public static func createInstance(_ d: TaqiDictionary) -> SubtitleModel {
        let file = d["file"] as? String
        let label = d["label"] as? String
        return SubtitleModel(file: file ?? "", label: label ?? "", source: .original)
    }
}

extension SubtitleModel {
    var webVTT: WebVTT? {
        if let srtText = SubtitleService.shared.getSubtitleText(file) {
            let _parser = WebVTTParser(string: srtText)
            var _webVTT = try? _parser.parse()  // *.vtt
            if _webVTT == nil {
                _webVTT = try? WebVTTParser.parseSubRip(srtText)    // *.srt
            }
            return _webVTT
        }
        return nil
    }
    
    var format: Format {
        if file.lowercased().contains("vtt") {
            return .vtt
        }
        return .srt
    }
}
