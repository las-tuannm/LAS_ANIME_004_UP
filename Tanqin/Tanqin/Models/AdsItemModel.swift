import Foundation

typealias TaDictionary = [String : Any?]

enum AdsName: String {
    case admob, applovin
}

enum AdsUnit: String {
    case banner, native, interstitial, open, reward
}

struct AdsItemModel {
    public let name: AdsName
    public let sort: Int?
    public let adUnits: [String]
    
    public func toDictionary() -> TaDictionary {
        return [
            "name": name.rawValue,
            "sort": sort,
            "adUnits": adUnits
        ]
    }
    
    public static func createInstance(_ d: TaDictionary) -> AdsItemModel {
        var name: AdsName = .admob
        if let _name = d["name"] as? String, let type = AdsName(rawValue: _name) {
            name = type
        }
        
        let sort = d["sort"] as? Int
        
        var adUnits: [String] = []
        if let s = d["adUnits"] as? String {
            adUnits = s.components(separatedBy: ",").map({ val in
                return val.trimmingCharacters(in: .whitespacesAndNewlines)
            })
        }
        
        return AdsItemModel(name: name, sort: sort, adUnits: adUnits)
    }
}

let adsesDefault: [AdsItemModel] = [
    AdsItemModel(name: .admob, sort: 1, adUnits: [AdsUnit.banner.rawValue, AdsUnit.native.rawValue, AdsUnit.open.rawValue]),
    AdsItemModel(name: .applovin, sort: 2, adUnits: [AdsUnit.banner.rawValue, AdsUnit.native.rawValue, AdsUnit.open.rawValue])
]


struct RevUserItemObject {
    let appid: String?
    let message: String?
    let forceUpdate: Bool?
    
    func toDictionary() -> TaDictionary {
        return [
            "appid": appid,
            "message": message,
            "forceUpdate": forceUpdate
        ]
    }
}

extension RevUserItemObject {
    static func createInstance(_ d: TaDictionary) -> RevUserItemObject {
        let appid = (d["appid"] as? String) ?? d["bundleId"] as? String
        let message = d["message"] as? String
        let forceUpdate = d["forceUpdate"] as? Bool
        return RevUserItemObject(appid: appid, message: message, forceUpdate: forceUpdate)
    }
}
