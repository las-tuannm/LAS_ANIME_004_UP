import UIKit
import Zip

extension Notification.Name {
    internal static let onSubtitles_did_update = Notification.Name("onSubtitles_did_update")
}

class SubtitleService: NSObject {
    var subtitleSelected: SubtitleModel? = nil  // nil when off sub
    var onSubtitles: [SubtitleModel] = [] {
        didSet {
            NotificationCenter.default.post(name: .onSubtitles_did_update, object: nil)
        }
    }
    var vSubtitles: [SubtitleModel] = []
    var vSubtitlesByLang: [SubtitleModel] {
        return vSubtitles
    }
    
    static let shared = SubtitleService()
    
    // MARK: - private
    func tempSubDir() -> URL {
        let tempDirectoryPath = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempSub = tempDirectoryPath.appendingPathComponent("subtitles")
        
        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: tempSub.path, isDirectory: &isDir) {
            try? FileManager.default.createDirectory(at: tempSub, withIntermediateDirectories: true)
        }
        
        return tempSub
    }
    
    // MARK: - public
    func cleanSubDir() {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: tempSubDir(),
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        }
        catch {
            
        }
    }
    
    private func fileCachedURL(_ link: String) -> URL {
        let hash = link.md5()
        let fileCached = tempSubDir().appendingPathComponent(hash)
        return fileCached
    }
    
    func getSubtitleText(_ link: String) -> String? {
        if let data = try? Data(contentsOf: fileCachedURL(link)), let srtText = String(data: data, encoding: .utf8) {
            return srtText
        }
        return nil
    }
    
    func downloadSubVTT(link: String, completion: @escaping (_ webVTT: WebVTT?) -> Void) {
        if let srtText = getSubtitleText(link) {
            let parser = WebVTTParser(string: srtText)
            let webVTT = try? parser.parse()
            completion(webVTT)
            return
        }
        
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            var webVTT: WebVTT? = nil
            var text: String? = nil
            
            if let _data = data {
                if let _gunzipData = _data.gunzip(), let s = String(data: _gunzipData, encoding: .utf8) {
                    text = s
                }
                else if let s = String(data: _data, encoding: .utf8) {
                    text = s
                }
            }
            
            if text != nil {
                try? text!.write(to: self.fileCachedURL(link), atomically: true, encoding: .utf8)
                
                let parser = WebVTTParser(string: text!)
                webVTT = try? parser.parse()
            }
            
            completion(webVTT)
        }.resume()
    }
    
    func downloadSubSRT(link: String, completion: @escaping (_ webVTT: WebVTT?) -> Void) {
        if let srtText = getSubtitleText(link) {
            let webVTT = try? WebVTTParser.parseSubRip(srtText)
            completion(webVTT)
            return
        }
        
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            var webVTT: WebVTT? = nil
            var text: String? = nil
            
            if let _data = data {
                if let _gunzipData = _data.gunzip(), let s = String(data: _gunzipData, encoding: .utf8) {
                    text = s
                }
                else if let s = String(data: _data, encoding: .utf8) {
                    text = s
                }
            }
            
            if text != nil {
                try? text!.write(to: self.fileCachedURL(link), atomically: true, encoding: .utf8)
                
                webVTT = try? WebVTTParser.parseSubRip(text!)
            }
            
            completion(webVTT)
        }.resume()
    }
    
    func downloadSubScene(link: String, completion: @escaping (_ webVTT: WebVTT?) -> Void) {
        if let srtText = getSubtitleText(link) {
            let webVTT = try? WebVTTParser.parseSubRip(srtText)
            completion(webVTT)
            return
        }
        
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            var webVTT: WebVTT? = nil
            var text: String? = nil
            
            if let _data = data {
                do {
                    let tempDirectoryPath = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                    let fileSub = tempDirectoryPath.appendingPathComponent("scene.zip")
                    let tempSub = tempDirectoryPath.appendingPathComponent("scene")
                    
                    // remove tempSub folder
                    try? FileManager.default.removeItem(at: tempSub)
                    
                    // save file zip
                    try _data.write(to: fileSub)
                    
                    // unzip
                    try Zip.unzipFile(fileSub, destination: tempSub, overwrite: true, password: nil)
                    
                    // find srt file and read content
                    for filename in (try? FileManager.default.contentsOfDirectory(atPath: tempSub.path)) ?? [] {
                        let fileURL = tempSub.appendingPathComponent(filename)
                        let dataUnzip = try Data(contentsOf: fileURL)
                        if let s = String(data: dataUnzip, encoding: .utf8) {
                            text = s
                            break
                        }
                    }
                } catch { }
            }
            
            if text != nil {
                try? text!.write(to: self.fileCachedURL(link), atomically: true, encoding: .utf8)
                
                webVTT = try? WebVTTParser.parseSubRip(text!)
            }
            
            completion(webVTT)
        }.resume()
    }
    
}
