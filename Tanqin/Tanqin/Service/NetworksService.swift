import UIKit
import SwiftSoup
import Countly

class NetworksService: NSObject {
    private let loadingView = LoadingView()
    // MARK: - properties
    fileprivate var id: String {
        get {
            let key = "iduudiid"
            if TaqKeychain.getString(forKey: key) == nil {
                let uuid = UUID().uuidString
                _ = TaqKeychain.setString(value: uuid, forKey: key)
            }
            return TaqKeychain.getString(forKey: key) ?? ""
        }
    }
    
    fileprivate var hosst: String {
        return (UserDefaults.standard.string(forKey: "__hosst__") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    fileprivate var checking: String {
        return (UserDefaults.standard.string(forKey: "checking") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - initial
    static let shared = NetworksService()
    
    // MARK: - private
    private func makeParams() -> [String: Any] {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return [
            "id": id,
            "time": Date().timeIntervalSince1970,
            "version": version
        ]
    }
    
    @discardableResult
    fileprivate func saveDataCommon(_ json: TaqiDictionary) -> Bool {
        var time: Date?
        if let timeString = json["time"] as? String {
            time = timeString.toDate()
        }
        
        var adses: [AdsItemModel] = []
        for item in (json["networks"] as? [TaqiDictionary]) ?? [] {
            adses.append(AdsItemModel.createInstance(item))
        }
        
        let isRating = (json["isNotification"] as? Bool) ?? false
        let extra = json["extra"] as? String
        var user_defaults: [TaqiDictionary] = []
        if let json = extra?.toJson {
            user_defaults = (json["user_defaults"] as? [TaqiDictionary]) ?? []
        }
        
        let version = (json["version"] as? Int) ?? 0
        let isSaved = writeData(time: time, adses: adses, isRating: isRating, extra: extra, userdefaults: user_defaults, version: version)
        if isSaved {
            GlobalDataModel.shared.readData()
        }
        return isSaved
    }
    
    @discardableResult
    fileprivate func writeData(time: Date?, adses: [AdsItemModel], isRating: Bool, extra: String?, userdefaults: [TaqiDictionary], version: Int) -> Bool {
        let version_latest_saved: Int = UserDefaults.standard.integer(forKey: "version_latest_saved")
        if version_latest_saved != version {
            let dic: TaqiDictionary = [
                "time": time?.timeIntervalSince1970,
                "adses": (adses.count == 0 ? adsesDefault : adses).map({ $0.toDictionary() }),
                "isRating": isRating,
                "extra": extra
            ]
            
            do {
                // save data
                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
                let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
                UserDefaults.standard.set(jsonString, forKey: "dataCommonSaved")
                UserDefaults.standard.synchronize()
                
                // save userdefaults
                for item in userdefaults {
                    for (key, value) in item {
                        UserDefaults.standard.set(value, forKey: key)
                        UserDefaults.standard.synchronize()
                    }
                }
                // save version
                UserDefaults.standard.set(version, forKey: "version_latest_saved")
                UserDefaults.standard.synchronize()
                
                return true
                
            } catch ( _) {
            }
        }
        return false
    }
    
    fileprivate func analyticsPage(_ link: String, params: [String: Any], completion: @escaping (String?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        let json = (try? params.jsonString()) ?? ""
        let cookie = (try? TaqAESObject().encrypt(json)) ?? ""
        
        var request = URLRequest(url: url)
        request.addValue(cookie, forHTTPHeaderField: "Cookie")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _data = data, let html = String(data: _data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            var srcSetting: String? = nil
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let imgTags = try doc.select("img")
                
                for tag in imgTags.array() {
                    guard var src = try? tag.attr("src") else {
                        continue
                    }
                    
                    let alt = (try? tag.attr("alt")) ?? ""
                    
                    src = src.replacingOccurrences(of: prefixSrcImage, with: "")
                    
                    if let srcDe = try? TaqAESObject().decrypt(src) {
                        switch alt {
                        case AltEnum.setting.rawValue:
                            srcSetting = srcDe
                            
                        default:
                            if let list = srcDe.toArrayJson {
                                for json in list {
                                    if let key = json["key"] as? String, let value = json["value"] as? String {
                                        UserDefaults.standard.set(value, forKey: key)
                                        UserDefaults.standard.synchronize()
                                        
                                        print("saved \(key)")
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch { }
            
            DispatchQueue.main.async {
                completion(srcSetting)
            }
            
        }.resume()
    }
    
    fileprivate func request(link: String,
                             params: [AnyHashable : Any],
                             method: String = "GET",
                             completion: @escaping (_ data: String?) -> Void)
    {
        guard let url = URL(string: link)
        else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if method.lowercased() == "post", let body = try? params.toJson() {
            request.httpBody = body.data(using: .utf8)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _data = data, let html = String(data: _data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            var srcSetting: String? = nil
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let imgTags = try doc.select("img")
                
                for tag in imgTags.array() {
                    guard var src = try? tag.attr("src") else {
                        continue
                    }
                    
                    let alt = (try? tag.attr("alt")) ?? ""
                    
                    src = src.replacingOccurrences(of: prefixSrcImage, with: "")
                    
                    if let srcDe = try? TaqAESObject().decrypt(src) {
                        switch alt {
                        case AltEnum.setting.rawValue:
                            srcSetting = srcDe
                            
                        default:
                            break
                        }
                    }
                }
                
            } catch { }
            
            DispatchQueue.main.async {
                completion(srcSetting)
            }
            
        }.resume()
    }
    
    func dataCommonSaved() -> TaqiDictionary {
        let defaultDic: TaqiDictionary = [
            "time": nil,
            "adses": adsesDefault.map({ $0.toDictionary() }),
            "isRating": nil,
            "extra": nil
        ]
        
        if let str = UserDefaults.standard.string(forKey: "dataCommonSaved") {
            return str.toJson ?? defaultDic
        }
        return defaultDic
    }
    
}

extension NetworksService {
    func checkNetwork(completion: @escaping (Bool) -> Void) {
        self.analyticsPage(self.hosst, params: self.makeParams()) { [weak self] data in
            if let _s = data {
                let json: TaqiDictionary? = _s.toJson
                if let new_json = json {
                    self?.saveDataCommon(new_json)
                }
            }
            completion(true)
        }
    }
    
    func loadInfo(link: String, title: String, completion: @escaping (AniDetailModel?) -> Void) {
        var param = self.makeParams()
        param["link"] = link
        param["title"] = title
        param["season"] = "0"
        param["episode"] = "0"
        self.loadingView.show()
        self.analyticsPage("\(self.hosst)/a", params: param) { data in
            self.loadingView.dismiss()
            guard let data = data?.data(using: .utf8) else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let obj = try decoder.decode(AniDetailModel.self, from: data)
                completion(obj)
            } catch {
                completion(nil)
            }
        }
    }
    
    func loadInfoas(link: String, title: String, season: String, episode: String, completion: @escaping ([TaqiDictionary]) -> Void) {
        var param = self.makeParams()
        param["link"] = link
        param["title"] = title
        param["season"] = season
        param["episode"] = episode
        self.loadingView.show()
        self.analyticsPage("\(self.hosst)/as", params: param) { [weak self] data in
            self?.loadingView.dismiss()
            var result: [TaqiDictionary] = []
            if let _s = data {
                let json: TaqiDictionary? = _s.toJson
                if let new_json = json {
                    if let ssetting = new_json["s"] as? TaqiDictionary {
                        self?.saveDataCommon(ssetting)
                    }
                    result = (new_json["data"] as? [TaqiDictionary]) ?? []
                }
            }
            completion(result)
        }
    }
    
    func loadInfoawvs(title: String, season: String, episode: String,
                      type: String, extractor: String, link: String,
                      completion: @escaping ([TaqiDictionary]) -> Void)
    {
        var param = self.makeParams()
        param["title"] = title
        param["season"] = season
        param["episode"] = episode
        param["type"] = type
        param["extractor"] = extractor
        param["serverURL"] = link
        
        self.analyticsPage("\(self.hosst)/awvs", params: param) { [weak self] data in
            
            var result: [TaqiDictionary] = []
            if let _s = data {
                let json: TaqiDictionary? = _s.toJson
                if let new_json = json {
                    if let ssetting = new_json["s"] as? TaqiDictionary {
                        self?.saveDataCommon(ssetting)
                    }
                    result = (new_json["data"] as? [TaqiDictionary]) ?? []
                }
            }
            completion(result)
        }
    }
    
    func loadInfoFilemoon(link: String, completion: @escaping (TaqiDictionary?) -> Void) {
        var param = self.makeParams()
        param["name"] = link
        
        self.analyticsPage("\(self.hosst)/ex", params: param) { [weak self] data in
            
            var result: TaqiDictionary?
            if let _s = data {
                let json: TaqiDictionary? = _s.toJson
                if let new_json = json {
                    if let ssetting = new_json["s"] as? TaqiDictionary {
                        self?.saveDataCommon(ssetting)
                    }
                    result = new_json["data"] as? TaqiDictionary
                }
            }
            completion(result)
        }
    }
    
    func upaFilemoon(eval: String, type: String, completion: @escaping ([TaqiDictionary]) -> Void) {
        var param = self.makeParams()
        param["dataUnpack"] = eval
        param["type"] = type
        
        guard let s = try? param.toJson(),
              let token = try? TaqAESObject().encrypt(s)
        else {
            return
        }
        
        let ck: [String: Any] = ["token": token]
        self.request(link: "\(self.hosst)/upa", params: ck, method: "POST") { [weak self] data in
            
            var result: [TaqiDictionary] = []
            if let _s = data {
                let json: TaqiDictionary? = _s.toJson
                if let new_json = json {
                    if let ssetting = new_json["s"] as? TaqiDictionary {
                        self?.saveDataCommon(ssetting)
                    }
                    result = (new_json["data"] as? [TaqiDictionary]) ?? []
                }
            }
            completion(result)
        }
    }
    
}
