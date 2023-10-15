//
//  GithubService.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 02/10/2023.
//

import Foundation
import RxSwift

enum APIPath: String {
    case animeQuote = "/khanhVu-ops/TestJsonData/main/anime_data/anime_quote.json"
    case animeShort = "/khanhVu-ops/TestJsonData/main/anime_data/anime_short.json"
    case animeQuoteDay = "/khanhVu-ops/TestJsonData/main/anime_data/anime_quote_day.json"
    
    enum FanArt: String, CaseIterable {
        
        case gintama = "/khanhVu-ops/TestJsonData/main/anime_data/fan_art/gintama.json"
        case honkai_tag = "/khanhVu-ops/TestJsonData/main/anime_data/fan_art/honkai_tag.json"
        case jujutsu_kaisen = "/khanhVu-ops/TestJsonData/main/anime_data/fan_art/jujutsu_kaisen.json"
        case nisekoi = "/khanhVu-ops/TestJsonData/main/anime_data/fan_art/nisekoi.json"
        case one_piece = "/khanhVu-ops/TestJsonData/main/anime_data/fan_art/one_piece.json"
        case oshi_no_ko = "/khanhVu-ops/TestJsonData/main/anime_data/fan_art/oshi_no_ko.json"
        case suki_na_ko_ga_Megane_wo_Wasureta = "/khanhVu-ops/TestJsonData/main/anime_data/fan_art/suki_na_ko_ga_Megane_wo_Wasureta.json"
        case vocaloid = "/khanhVu-ops/TestJsonData/main/anime_data/fan_art/vocaloid.json"
        
//        var id: Int {
//            switch self {
//            case .oshi_no_ko:
//                return 0
//            case .jujutsu_kaisen:
//                return 1
//            case .one_piece:
//                return 2
//            case .honkai_tag:
//                return 3
//            case .gintama:
//                return 4
//            case .nisekoi:
//                return 5
//            case .vocaloid:
//                return 6
//            case .suki_na_ko_ga_Megane_wo_Wasureta:
//                return 7
//            }
//        }
    }
}

class GithubService: BaseService {
    static let shared = GithubService()
    
    private override init() {
        super.init()
    }
    
    func getAnimeQuote() -> Single<AnimeQuoteModel>{
        return rxRequest(APIPath.animeQuote.rawValue, .get, of: AnimeQuoteModel.self)
    }
    
    func getAnimeQuoteDay() -> Single<AnimeQuoteDayModel> {
        return rxRequest(APIPath.animeQuoteDay.rawValue, .get, of: AnimeQuoteDayModel.self)
    }
    
    func getAnimeShort() -> Single<AnimeShortsModel> {
        return rxRequest(APIPath.animeShort.rawValue, .get, of: AnimeShortsModel.self)
    }
    
    func getFanArtGintama() -> Single<FanArtModel> {
        return rxRequest(APIPath.FanArt.gintama.rawValue, .get, of: FanArtModel.self)
    }
    
    func getFanArtHonkaiTag() -> Single<FanArtModel> {
        return rxRequest(APIPath.FanArt.honkai_tag.rawValue, .get, of: FanArtModel.self)
    }
    
    func getFanArtJujutsuKaisen() -> Single<FanArtModel> {
        return rxRequest(APIPath.FanArt.jujutsu_kaisen.rawValue, .get, of: FanArtModel.self)
    }
    
    func getFanArtNisekoi() -> Single<FanArtModel> {
        return rxRequest(APIPath.FanArt.nisekoi.rawValue, .get, of: FanArtModel.self)
    }
    
    func getFanArtOnePiece() -> Single<FanArtModel> {
        return rxRequest(APIPath.FanArt.one_piece.rawValue, .get, of: FanArtModel.self)
    }
    
    func getFanArtOshiNoKo() -> Single<FanArtModel> {
        return rxRequest(APIPath.FanArt.oshi_no_ko.rawValue, .get, of: FanArtModel.self)
    }
    
    func getFanArtSukiNaKoGa() -> Single<FanArtModel> {
        return rxRequest(APIPath.FanArt.suki_na_ko_ga_Megane_wo_Wasureta.rawValue, .get, of: FanArtModel.self)
    }
    
    func getFanArtVocaloid() -> Single<FanArtModel> {
        return rxRequest(APIPath.FanArt.vocaloid.rawValue, .get, of: FanArtModel.self)
    }
    
    func fetchYouTubeThumbnail(shortUrl: String, completion: @escaping (URL?) -> Void) {
        // Construct the URL to fetch video details from YouTube
        let id = getId(url: shortUrl)
        let apiUrl = "https://www.googleapis.com/youtube/v3/videos?key=\(Configuration.googleAPIKey)&part=snippet&id=\(id)"
        
        if let url = URL(string: apiUrl) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                    if let items = json["items"] as? [[String: Any]], let item = items.first,
                       let snippet = item["snippet"] as? [String: Any],
                       let thumbnails = snippet["thumbnails"] as? [String: Any],
                       let defaultThumbnail = thumbnails["standard"] as? [String: Any],
                       let thumbnailUrlString = defaultThumbnail["url"] as? String,
                       let thumbnailUrl = URL(string: thumbnailUrlString) {
                        completion(thumbnailUrl)
                        return
                    }
                }
                // If something goes wrong, return nil
                completion(nil)
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    func getId(url: String) -> String {
        let components = url.components(separatedBy: "/")
        guard let videoID = components.last  else {
            print("Failed to extract video ID.")
            return ""
        }
        return videoID
    }
}
