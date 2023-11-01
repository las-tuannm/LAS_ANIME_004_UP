import UIKit

struct AniModel: Codable {
    let id: String          // for all
    let enName: String      // for all
    let jpName: String      // for all
    let posterLink: String  // for all
    let detailLink: String  // for all
    let quality: String     // only 9an
    let sub: String         // for all
    let eps: String         // for all
    var view: String? = ""   // only ani
    var dub: String? = ""    // only ani
    var type: String? = ""   // only ani
    var rate: String? = ""   // only ani
}

extension AniModel {
    var posterURL: URL? {
        return URL(string: posterLink)
    }
    
    var detailURL: URL? {
        return URL(string: detailLink)
    }
}

struct AniDetailModel: Codable {
    let id: String
    let posterLink: String
    let enName: String
    let jpName: String
    let alias: String
    let description: String
    let type: String
    let studios: String
    let dateAired: String
    let status: String
    let genres: [AniGenreModel]
    let scores: String
    let premiered: String
    let duration: String
    let quality: String
    let views: String
    let episode: [AniEpisodesModel]
    let suggestion: [AniModel]?
    let season: [AniSeasonModel]?
}

extension AniDetailModel {
    var posterURL: URL? {
        return URL(string: posterLink)
    }
    
    func toAniModel(link: String) -> AniModel {
        return AniModel(id: id, enName: enName, jpName: jpName, posterLink: posterLink, detailLink: link, quality: "", sub: "", eps: "")
    }
    
    var isEmpty: Bool {
        return description.count < 10 && suggestion?.count == 0 && episode.count == 0
    }
}

struct AniEpisodesModel: Codable {
    let link: String
    let sourceID: String
    let title: String
    let season: String
    let episode: String
}

struct AniSerModel: Codable {
    let id: String
    let name: String
    let type: String
}

struct AniSerDetailModel: Codable {
    let url: String
    let skip_data: String
}

struct AniSeasonModel: Codable {
    let name: String
    let detailLink: String
    let posterLink: String
}

extension AniSeasonModel {
    var detailURL: URL? {
        return URL(string: detailLink)
    }
    
    var posterURL: URL? {
        return URL(string: posterLink)
    }
}

class RecentAni: NSObject {
    var id: String = ""
    var posterLink: String = ""
    var enName: String = ""
    var detailLink: String = ""
    var source: String = ""
    var season: String = ""
    var episode: String = ""
    var sourceId: String = ""
    
    override init() {
        
    }
    
    init(_ dictionary: [String: Any]) {
        if let val = dictionary["id"] as? String { id = val }
        if let val = dictionary["posterLink"] as? String { posterLink = val }
        if let val = dictionary["enName"] as? String { enName = val }
        if let val = dictionary["detailLink"] as? String { detailLink = val }
        if let val = dictionary["source"] as? String { source = val }
        if let val = dictionary["season"] as? String { season = val }
        if let val = dictionary["episode"] as? String { episode = val }
        if let val = dictionary["sourceId"] as? String { sourceId = val }
    }
   
    func checkValueEqual(recentAni: RecentAni) -> Bool {
        if (self.id == recentAni.id && self.source == recentAni.source) {
            return true
        } else {
            return false
        }
    }
    
    func toString() -> [String: Any] {
        return ["id": id,
                "posterLink": posterLink,
                "enName": enName,
                "detailLink": detailLink,
                "source": source,
                "season": season,
                "episode": episode,
                "sourceId": sourceId]
    }
    
    static func getRecentAni(id: String) -> RecentAni? {
        let recentAnis = getAllRecentAni()
        var recentTemp: RecentAni?
        let recent = RecentAni()
        recent.id = id
        recent.source = HTMLService.shared.getSourceAnime().getTitleSource()
        
        for item in recentAnis {
            if item.checkValueEqual(recentAni: recent) {
                if item.source == HTMLService.shared.getSourceAnime().getTitleSource() {
                    recentTemp = item
                }
            }
        }
        
        return recentTemp
    }
    
    static func getAllRecentAni() -> [RecentAni] {
        let string = readString(fileName: "list_recent_ani.json")
        if string == nil || string == "" {
            return [RecentAni]()
        }
        let data: [[String: Any]] = dataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [RecentAni]()
        for item in data {
            let model = RecentAni(item)
            if model.source == HTMLService.shared.getSourceAnime().getTitleSource() {
                result.append(model)
            }
        }
        return result
    }
    
    static func addRecentAni(recentAni: RecentAni) {
        let recentAnis = getAllRecentAni()
        var recentAniTemp = [RecentAni]()
        recentAniTemp.append(recentAni)
        var countCurrentRecentForSource = 0
        for item in recentAnis {
            if !item.checkValueEqual(recentAni: recentAni) {
                if item.source == HTMLService.shared.getSourceAnime().getTitleSource() {
                    if countCurrentRecentForSource < 15 {
                        countCurrentRecentForSource = countCurrentRecentForSource + 1
                        recentAniTemp.append(item)
                    }
                } else {
                    recentAniTemp.append(item)
                }
            }
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: recentAniTemp.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(aString: jsonString, fileName: "list_recent_ani.json")
            }
        } catch {
            print("\(error)")
        }
    }
    
    static func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch let myJSONError {
            print("convert to json error: \(myJSONError)")
        }
        return nil
    }
}
