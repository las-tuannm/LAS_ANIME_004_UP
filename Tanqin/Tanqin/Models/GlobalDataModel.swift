import Foundation

struct GlobalDataModel {
    fileprivate var time: Date?
    fileprivate var extra: String? {
        didSet {
            if let json = extra?.toJson {
                extraJSON = json
            } else {
                extraJSON = nil
            }
        }
    }
    fileprivate var extraJSON: TaDictionary?
    
    fileprivate var _allAds: [AdsItemModel] = adsesDefault
    fileprivate var adsActtive: [AdsItemModel] {
        return _allAds.sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
    }
    
    public var openRatingView: Bool {
        guard let _time = time,
              let _opemtime = UserDefaults.standard.object(forKey: "ffoottime") as? Date
        else {
            return false
        }
        
        if UserDefaults.standard.bool(forKey: "time_changed") {
            return false
        }
        
        let nTime: Int? = self.extraFind("in_time")
        if let _nTime = nTime {
            return Date().timeIntervalSince1970 >= _opemtime.timeIntervalSince1970 + TimeInterval(_nTime)
        }
        else {
            return _time.timeIntervalSince1970 >= _opemtime.timeIntervalSince1970
        }
    }
    
    public var isRating: Bool = false
    
    // MARK: - static instance
    public static var shared = GlobalDataModel()
    
    init() { }
    
    // MARK: - keys admob
    @LocalStorage(key: "admob_banner", value: "ca-app-pub-2299291161271404/9102730363")
    public var admob_banner: String
    
    @LocalStorage(key: "admob_inter", value: "ca-app-pub-2299291161271404/1049567250")
    public var admob_inter: String
    
    @LocalStorage(key: "admob_inter_splash", value: "ca-app-pub-2299291161271404/9440845552")
    public var admob_inter_splash: String
    
    @LocalStorage(key: "admob_reward", value: "ca-app-pub-2299291161271404/5501600544")
    public var admob_reward: String
    
    @LocalStorage(key: "admob_reward_interstitial", value: "ca-app-pub-2299291161271404/8127763889")
    public var admob_reward_interstitial: String
    
    @LocalStorage(key: "admob_small_native", value: "ca-app-pub-2299291161271404/4188518877")
    public var admob_small_native: String
    
    @LocalStorage(key: "admob_medium_native", value: "ca-app-pub-2299291161271404/7724439200")
    public var admob_medium_native: String
    
    @LocalStorage(key: "admob_manual_native", value: "ca-app-pub-2299291161271404/6000293994")
    public var admob_manual_native: String
    
    @LocalStorage(key: "admob_appopen", value: "ca-app-pub-2299291161271404/6296603621")
    public var admob_appopen: String
    
    
    // MARK: - keys applovin
    @LocalStorage(key: "applovin_banner", value: "08328e76be456160")
    public var applovin_banner: String
    
    @LocalStorage(key: "applovin_inter", value: "3ca8cf57db99e76d")
    public var applovin_inter: String
    
    @LocalStorage(key: "applovin_inter_splash", value: "34ce7c015b4b0b5a")
    public var applovin_inter_splash: String
    
    @LocalStorage(key: "applovin_reward", value: "49499e202d5a3dd3")
    public var applovin_reward: String
    
    @LocalStorage(key: "applovin_small_native", value: "a657caf023b47cb4")
    public var applovin_small_native: String
    
    @LocalStorage(key: "applovin_medium_native", value: "a0ffa8e04de167e1")
    public var applovin_medium_native: String
    
    @LocalStorage(key: "applovin_manual_native", value: "9b88df432799fc6f")
    public var applovin_manual_native: String
    
    @LocalStorage(key: "applovin_appopen", value: "396ad4604c998f2f")
    public var applovin_appopen: String
    
    //
    @LocalStorage(key: "applovin_apikey", value: "")
    public var applovin_apikey: String
}

extension GlobalDataModel {
    public func extraFind<T>(_ key: String) -> T? {
        return (extraJSON ?? [:])[key] as? T
    }
    
    public func adsAvailableFor(_ name: AdsName) -> AdsItemModel? {
        return self.adsActtive.filter({ $0.name == .admob }).first
    }
    
    public func adsAvailableFor(_ unit: AdsUnit) -> [AdsItemModel] {
        return self.adsActtive.filter({ $0.adUnits.contains(unit.rawValue) }).sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
    }
    
    public func isAvailable(_ name: AdsName, _ unit: AdsUnit) -> Bool {
        return self.adsAvailableFor(unit).contains(where: { $0.name == name })
    }
    
    public mutating func readData() {
        let data = NetworksService.shared.dataCommonSaved()
        
        if let timestamp = data["time"] as? TimeInterval {
            self.time = Date(timeIntervalSince1970: timestamp)
        }
        if let listAds = data["adses"] as? [TaqiDictionary] {
            self._allAds.removeAll()
            for dic in listAds {
                if let name = dic["name"] as? String, let type = AdsName(rawValue: name) {
                    let m = AdsItemModel(name: type, sort: dic["sort"] as? Int, adUnits: (dic["adUnits"] as? [String]) ?? [])
                    self._allAds.append(m)
                }
            }
        }
        self.isRating = (data["isRating"] as? Bool) ?? false
        self.extra = data["extra"] as? String
    }
    
}
