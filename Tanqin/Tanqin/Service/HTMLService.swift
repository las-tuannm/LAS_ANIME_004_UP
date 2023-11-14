import UIKit
import SwiftSoup

enum SourceAnime {
    case aniware, anime9
    
    func getTitleSource() -> String {
        switch self {
        case .aniware:
            return "QW5pd2FyZQ==".fromBase64() ?? ""
        case .anime9:
            return "OWFuaW1l".fromBase64() ?? ""
        }
    }
    
    func getLinkSource() -> String {
        switch self {
        case .aniware:
            return "aHR0cHM6Ly9hbml3YXZlLnRv".fromBase64() ?? ""
        case .anime9:
            return "aHR0cHM6Ly85YW5pbWV0di50bw==".fromBase64() ?? ""
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .aniware:
            return UIImage(named: "ic_aniwave")
        case .anime9:
            return UIImage(named: "ic_9anime")
        }
    }
    
}

class HTMLService: NSObject {
    
    fileprivate var baseUrl: String {
        get {
            return domValue("aHR0cHM6Ly85YW5pbWV0di50bw==".fromBase64() ?? "", key: "host")
        }
    }
    
    // MARK: - initial
    static let shared = HTMLService()
    private let loadingView = LoadingView()
    
    override init() { }
    
    // MARK: - private
    fileprivate func logDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
        print(items, separator: separator, terminator: terminator)
#endif
    }
    
    fileprivate func domCFG() -> [String: Any]? {
        guard let data = domJSON.data(using: .utf8) else { return nil }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return json
        } catch {
            logDebug(error)
            return nil
        }
    }
    
    fileprivate func domValue(_ valDefault: String, key: String) -> String {
        guard let json = domCFG() else { return valDefault }
        
        return (json[key] as? String) ?? valDefault
    }
    
    fileprivate func fetchHTML(_ link: String, completion: @escaping (_ html: String?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(self.userAgent(), forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let unwrapData = data else {
                completion(nil)
                return
            }
            
            let html = String(data: unwrapData, encoding: .utf8)
            completion(html)
        }.resume()
    }
    
    // MARK: - public
    func userAgent() -> String {
        let userAgent = domValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
                                 key: "ua")
        return userAgent
    }
}

// MARK: - Helper
extension HTMLService {
    fileprivate func document(_ html: String?) -> Document? {
        guard let _html = html else { return nil }
        
        return try? SwiftSoup.parse(_html)
    }
    
    fileprivate func castToString(_ s: String?) -> String {
        return (s ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func getBaseList(_ doc: Document) -> [AniModel] {
        var result: [AniModel] = []
        
        do {
            let list = try doc.select(domValue("div.flw-item", key: "baseList-list"))
            for item in list {
                let id = castToString(try? item.attr(domValue("data-id", key: "baseList-id")))
                let enName = castToString(try? item.select(domValue("a.dynamic-name", key: "baseList-enName")).text())
                let jpName = castToString(try? item.select(domValue("a.dynamic-name", key: "baseList-jpName-1"))
                    .attr(domValue("data-jname", key: "baseList-jpName-2")))
                
                let quality = castToString(try? item.select(domValue("div.tick-quality", key: "baseList-quality")).text())
                let sub = castToString(try? item.select(domValue("div.tick-sub", key: "baseList-sub")).text())
                let eps = castToString(try? item.select(domValue("div.tick-eps", key: "baseList-eps")).text())
                let detailLink = "\(baseUrl)\(castToString(try? item.select(domValue("a.dynamic-name", key: "baseList-detail-1")).attr(domValue("href", key: "baseList-detail-2"))))"
                
                let posterLink = castToString(try? item.select(domValue("img.film-poster-img", key: "baseList-poster-1"))
                    .attr(domValue("data-src", key: "baseList-poster-2")))
                
                let ani = AniModel(id: id,
                                   enName: enName,
                                   jpName: jpName,
                                   posterLink: posterLink,
                                   detailLink: detailLink,
                                   quality: quality,
                                   sub: sub,
                                   eps: eps)
                
                if self.isAvailable(enName) {
                    result.append(ani)
                }
            }
            
        } catch {
            logDebug(error)
        }
        return result
    }
    
    fileprivate func isAvailable(_ name: String) -> Bool {
        let tmp = GlobalDataModel.shared.nameNotAvailable()
        for it in tmp {
            if name.lowercased().contains(it) {
                return false
            }
        }
        return true
    }
}

extension HTMLService {
    private enum TopOption {
        case today, week, month
    }
    
    private func getTopItem(_ doc: Document, _ top: TopOption = .today) -> [AniModel] {
        var result: [AniModel] = []
        do {
            var tab = ""
            var list: Elements!
            if top == .today {
                tab = domValue("div#top-viewed-day > ul > li", key: "topItem-list-day")
            } else if top == .week {
                tab = domValue("div#top-viewed-week > ul > li", key: "topItem-list-week")
            } else if top == .month {
                tab = domValue("div#top-viewed-month > ul > li", key: "topItem-list-month")
            }
            
            list = try doc.select(tab)
            for item in list {
                let id = castToString(try? item.select(domValue("div.film-poster", key: "topItem-id-1")).attr(domValue("data-id", key: "topItem-id-2")))
                let name = castToString(try? item.select(domValue("h3.film-name", key: "topItem-name")).text())
                let quality = ""
                let sub = ""
                let eps = ""
                let view = castToString(try? item.select(domValue("div.fd-infor", key: "topItem-view")).text())
                let detailLink = "\(baseUrl)\(castToString(try? item.select(domValue("h3.film-name > a", key: "topItem-detail-1")).attr(domValue("href", key: "topItem-detail-2"))))"
                
                let posterLink = castToString(try? item.select(domValue("div.film-poster > img", key: "topItem-poster-1")).attr(domValue("data-src", key: "topItem-poster-2")))
                
                var ani = AniModel(id: id,
                                   enName: name,
                                   jpName: "",
                                   posterLink: posterLink,
                                   detailLink: detailLink,
                                   quality: quality,
                                   sub: sub,
                                   eps: eps)
                ani.view = view
                
                if self.isAvailable(name) {
                    result.append(ani)
                }
            }
        } catch {
            logDebug(error)
        }
        return result
    }
    
    private func getTrending(_ doc: Document) -> [AniModel] {
        var trending: [AniModel] = []
        do {
            let list = try doc.select(domValue("div.swiper-slide", key: "trending-list"))
            for item in list {
                let posterLink = castToString(try? item.select(domValue("img", key: "trending-poster-1")).first()?.attr(domValue("src", key: "trending-poster-2")))
                
                let name = castToString(try? item.select(domValue("div.desi-head-title", key: "trending-name")).text())
                
                let detailLink = "\(baseUrl)\(castToString(try? item.select(domValue("div.desi-buttons > a", key: "trending-detail-1")).attr(domValue("href", key: "trending-detail-2"))))"
                
                var id = ""
                if let last = detailLink.components(separatedBy: "-").last, last.isNumber {
                    id = last
                }
                
                let ani = AniModel(id: id,
                                   enName: name,
                                   jpName: "",
                                   posterLink: posterLink,
                                   detailLink: detailLink,
                                   quality: "",
                                   sub: "",
                                   eps: "")
                
                if self.isAvailable(name) {
                    trending.append(ani)
                }
            }
        } catch {
            logDebug(error)
        }
        return trending
    }
    
    private func getRecently(_ doc: Document) -> [AniModel] {
        var recently: [AniModel] = []
        
        do {
            let list = try doc.select(domValue("div.flw-item", key: "recently-list"))
            for item in list {
                let id = castToString(try? item.attr(domValue("data-id", key: "recently-id")))
                let enName = castToString(try? item.select(domValue("a.dynamic-name", key: "recently-enName")).text())
                let jpName = castToString(try? item.select(domValue("a.dynamic-name", key: "recently-jpName-1")).attr(domValue("data-jname", key: "recently-jpName-2")))
                
                let quality = castToString(try? item.select(domValue("div.tick-quality", key: "recently-quality")).text())
                let sub = castToString(try? item.select(domValue("div.tick-sub", key: "recently-sub")).text())
                let eps = castToString(try? item.select(domValue("div.tick-eps", key: "recently-eps")).text())
                let detailLink = "\(baseUrl)\(castToString(try? item.select(domValue("a.dynamic-name", key: "recently-detail-1")).attr(domValue("href", key: "recently-detail-2"))))"
                
                let posterLink = castToString(try? item.select(domValue("div.film-poster > img", key: "recently-poster-1")).attr(domValue("data-src", key: "recently-poster-2")))
                
                let ani = AniModel(id: id,
                                   enName: enName,
                                   jpName: jpName,
                                   posterLink: posterLink,
                                   detailLink: detailLink,
                                   quality: quality,
                                   sub: sub,
                                   eps: eps)
                
                if self.isAvailable(enName) {
                    recently.append(ani)
                }
            }
            
        } catch {
            logDebug(error)
        }
        return recently
    }
    
    private func getGenre(_ doc: Document) -> [AniGenreModel] {
        var result: [AniGenreModel] = []
        
        do {
            let list = try doc.select(domValue("ul.sub-menu > li > a[href*=/genre/]", key: "genre-list"))
            for item in list {
                let name = castToString(try? item.attr(domValue("title", key: "genre-name")))
                let detailLink = "\(baseUrl)\(castToString(try? item.attr(domValue("href", key: "genre-detail"))))"
                
                let genre = AniGenreModel(name: name, detailLink: detailLink)
                result.append(genre)
            }
            
        } catch {
            logDebug(error)
        }
        return result
    }
    
    func home(_ completion: @escaping (_ trending: [AniModel], _ recently: [AniModel],
                                       _ today: [AniModel], _ week: [AniModel], _ month: [AniModel], _ genre: [AniGenreModel]) -> Void)
    {
        self.loadingView.show()
        let link = "\(baseUrl)/home"
        
        self.fetchHTML(link) { [weak self] html in
            
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                self?.loadingView.dismiss()
                completion([], [], [], [], [], [])
                return
            }
            selfStrong.loadingView.dismiss()
            completion(selfStrong.getTrending(doc),
                       selfStrong.getRecently(doc),
                       selfStrong.getTopItem(doc, .today),
                       selfStrong.getTopItem(doc, .week),
                       selfStrong.getTopItem(doc, .month),
                       selfStrong.getGenre(doc))
        }
    }
}

extension HTMLService {
    func types() -> [AniGenreModel] {
        return [
            AniGenreModel(name: "TV Series", detailLink: "\(baseUrl)/tv", startColor: 0xA8C6FF, endColor: 0x4871E7),
            AniGenreModel(name: "Movies", detailLink: "\(baseUrl)/movie", startColor: 0x5285FE, endColor: 0xA74BFA),
            AniGenreModel(name: "OVAs", detailLink: "\(baseUrl)/ova", startColor: 0xFE52F0, endColor: 0xFA4BB2),
            AniGenreModel(name: "ONAs", detailLink: "\(baseUrl)/ona", startColor: 0xF9A432, endColor: 0xFAE24B),
            AniGenreModel(name: "Special", detailLink: "\(baseUrl)/special", startColor: 0x52EEFE, endColor: 0x0CC01A)
        ]
    }
    
    func genreDetail(page: Int, genre: AniGenreModel, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(genre.detailLink)?page=\(page)"
        self.loadingView.show()
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                self?.loadingView.dismiss()
                completion([])
                return
            }
            selfStrong.loadingView.dismiss()
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
        
    }
    
    func recentlyUpdated(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/recently-updated?page=\(page)"
        self.loadingView.show()
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                self?.loadingView.dismiss()
                completion([])
                return
            }
            selfStrong.loadingView.dismiss()
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
        
    }
    
    func recentlyAdded(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/recently-added?page=\(page)"
        self.loadingView.show()
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                self?.loadingView.dismiss()
                completion([])
                return
            }
            selfStrong.loadingView.dismiss()
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
        
    }
    
    func ongoing(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/ongoing?page=\(page)"
        self.loadingView.show()
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                self?.loadingView.dismiss()
                completion([])
                return
            }
            selfStrong.loadingView.dismiss()
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
        
    }
    
    func upcoming(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/upcoming?page=\(page)"
        self.loadingView.show()
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                self?.loadingView.dismiss()
                completion([])
                return
            }
            selfStrong.loadingView.dismiss()
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
}

extension HTMLService {
    enum TypeOption: String {
        case movie, tv, ova, ona, special
    }
    
    func typeDetail(page: Int, type: TypeOption, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/\(type.rawValue)?page=\(page)"
        
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([])
                return
            }
            
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
    
    func search(page: Int, term: String, completion: @escaping (_ data: [AniModel]) -> Void) {
        guard let url = URL(string: "\(baseUrl)/filter"),
              let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            completion([])
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "keyword", value: term),
            URLQueryItem(name: "type", value: ""),
            URLQueryItem(name: "status", value: "all"),
            URLQueryItem(name: "season", value: ""),
            URLQueryItem(name: "language", value: ""),
            URLQueryItem(name: "sort", value: "default"),
            URLQueryItem(name: "year", value: ""),
            URLQueryItem(name: "genre", value: ""),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let finalURL = urlComponents.url else {
            completion([])
            return
        }
        self.loadingView.show()
        self.fetchHTML(finalURL.absoluteString) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([])
                self?.loadingView.dismiss()
                return
            }
            selfStrong.loadingView.dismiss()
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
}

extension HTMLService {
    func getSourceAnime() -> SourceAnime {
        if let source = UserDefaults.standard.string(forKey: "source_anime"), source == "9anime" {
            return .anime9
        } else {
            return .aniware
        }
    }
    
    func setSourceAnime(sourceAnime: SourceAnime) {
        if sourceAnime == .anime9 {
            UserDefaults.standard.set("9anime", forKey: "source_anime")
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.set("aniwave", forKey: "source_anime")
            UserDefaults.standard.synchronize()
        }
        NotificationCenter.default.post(name: NSNotification.Name("change_source"), object: nil)
    }
}
