import UIKit
import SwiftSoup

fileprivate func castToString(_ s: String?) -> String {
    return (s ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
}

fileprivate func jsString(_ filename: String) -> String? {
    guard let url = Bundle.main.url(forAuxiliaryExecutable: filename) else { return nil }
    return try? String(contentsOf: url)
}

class AnWHTMLService: NSObject {
    
    fileprivate var baseUrl: String {
        get {
            return domValue("aHR0cHM6Ly9hbml3YXZlLnRv".fromBase64() ?? "", key: "host")
        }
    }
    
    // MARK: - initial
    static let shared = AnWHTMLService()
    private let loadingView = LoadingView()
    
    override init() { }
    
    // MARK: - private
    fileprivate func logDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
        print(items, separator: separator, terminator: terminator)
#endif
    }
    
    fileprivate func domCFG() -> [String: Any]? {
        guard let data = domJSON2.data(using: .utf8) else { return nil }
        
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
        
        let userAgent = domValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
                                 key: "ua")
        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let unwrapData = data else {
                completion(nil)
                return
            }
            
            let html = String(data: unwrapData, encoding: .utf8)
            completion(html)
        }.resume()
    }
    
    fileprivate func document(_ html: String?) -> Document? {
        guard let _html = html else { return nil }
        
        return try? SwiftSoup.parse(_html)
    }
    
    private func getBaseList(_ doc: Document) -> [AniModel] {
        var result: [AniModel] = []
        
        do {
            let list = try doc.select(domValue("div#list-items > div.item", key: "baseList-list"))
            for item in list {
                let id = castToString(try? item.select(domValue("div.poster", key: "baseList-id-1"))
                    .attr(domValue("data-tip", key: "baseList-id-2")))
                
                let posterImage = castToString(try? item.select(domValue("img", key: "baseList-poster-1")).attr(domValue("src", key: "baseList-poster-2")))
                
                let enName = castToString(try? item.select(domValue("a.d-title", key: "baseList-enName")).text())
                let jpName = castToString(try? item.select(domValue("a.d-title", key: "baseList-jpName-1")).attr(domValue("data-jp", key: "baseList-jpName-2")))
                
                let rate = castToString(try? item.select(domValue("div.meta > div.m-item", key: "baseList-rate")).last()?.text())
                let sub = castToString(try? item.select(domValue("span.sub", key: "baseList-sub")).text())
                let dub = castToString(try? item.select(domValue("span.dub", key: "baseList-dub")).text())
                let eps = castToString(try? item.select(domValue("span.total", key: "baseList-eps")).text())
                let type = castToString(try? item.select(domValue("div.right", key: "baseList-type")).text())
                let detailLink = "\(baseUrl)\(castToString(try? item.select(domValue("a.d-title", key: "baseList-detail-1")).attr(domValue("href", key: "baseList-detail-2"))))"
                
                var ani = AniModel(id: id,
                                   enName: enName,
                                   jpName: jpName,
                                   posterLink: posterImage,
                                   detailLink: detailLink,
                                   quality: "",
                                   sub: sub,
                                   eps: eps)
                ani.dub = dub
                ani.type = type
                ani.rate = rate
                
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
    
    // MARK: - public
    
}

extension AnWHTMLService {
    private enum TopOption {
        case today, week, month
    }
    
    private func getTopItem(_ doc: Document, _ top: TopOption = .today) -> [AniModel] {
        var result: [AniModel] = []
        do {
            var tab = ""
            var list: Elements!
            if top == .today {
                tab = domValue("div[data-name*=day]", key: "topItem-list-day")
            } else if top == .week {
                tab = domValue("div[data-name*=week]", key: "topItem-list-week")
            } else if top == .month {
                tab = domValue("div[data-name*=month]", key: "topItem-list-month")
            }
            
            list = try doc.select(tab).select(domValue("a.item", key: "topItem-list"))
            for item in list {
                let id = castToString(try? item.select(domValue("div.poster", key: "topItem-id-1")).attr(domValue("data-tip", key: "topItem-id-2")))
                
                let posterImage = castToString(try? item.select(domValue("img", key: "topItem-poster-1")).attr(domValue("src", key: "topItem-poster-2")))
                let enName = castToString(try? item.select(domValue("div.d-title", key: "topItem-enName")).text())
                let jpName = castToString(try? item.select(domValue("div.d-title", key: "topItem-jpName-1")).attr(domValue("data-jp", key: "topItem-jpName-2")))
                let quality = ""
                let sub = castToString(try? item.select(domValue("span.sub", key: "topItem-sub")).text())
                let dub = castToString(try? item.select(domValue("span.dub", key: "topItem-dub")).text())
                let eps = castToString(try? item.select(domValue("span.total", key: "topItem-eps")).text())
                let type = castToString(try? item.select(domValue("span.dot", key: "topItem-type")).last()?.text())
                let detailLink = "\(baseUrl)\(castToString(try? item.select(domValue("a.item", key: "topItem-detail-1")).attr(domValue("href", key: "topItem-detail-2"))))"
                
                var ani = AniModel(id: id,
                                   enName: enName,
                                   jpName: jpName,
                                   posterLink: posterImage,
                                   detailLink: detailLink,
                                   quality: quality,
                                   sub: sub,
                                   eps: eps)
                ani.dub = dub
                ani.type = type
                
                if self.isAvailable(enName) {
                    result.append(ani)
                }
            }
        } catch {
            logDebug(error)
        }
        return result
    }
    
    fileprivate func firstMatch(for regex: String, in text: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }.first
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getTrending(_ doc: Document) -> [AniModel] {
        var trending: [AniModel] = []
        do {
            let list = try doc.select(domValue("div.swiper-slide", key: "trending-list"))
            for item in list {
                var posterImage = castToString(try? item.select(domValue("div.image", key: "trending-poster-1"))
                    .select(domValue("div", key: "trending-poster-2"))
                    .attr(domValue("style", key: "trending-poster-3")))
                
                posterImage = self.firstMatch(for: "(https?://.*.(?:png|jpg))", in: posterImage) ?? ""
                
                let enName = castToString(try? item.select(domValue("h2.d-title", key: "trending-enName")).text())
                let jpName = castToString(try? item.select(domValue("h2.d-title", key: "trending-jpName-1")).attr(domValue("data-jp", key: "trending-jpName-2")))
                let quality = castToString(try? item.select(domValue("i.quality", key: "trending-quality")).text())
                let sub = castToString(try? item.select(domValue("i.sub", key: "trending-sub")).text())
                let detailLink = "\(baseUrl)\(castToString(try? item.select(domValue("div.actions > a", key: "trending-detail-1")).attr(domValue("href", key: "trending-detail-2"))))"
                let id = ""
                
                let ani = AniModel(id: id,
                                   enName: enName,
                                   jpName: jpName,
                                   posterLink: posterImage,
                                   detailLink: detailLink,
                                   quality: quality,
                                   sub: sub,
                                   eps: "")
                
                if self.isAvailable(enName) {
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
            let list = try doc.select(domValue("section#recent-update", key: "recently-list-1"))
                .select(domValue("div.ani", key: "recently-list-2"))
                .select(domValue("div.item", key: "recently-list-3"))
            
            for item in list {
                let id = castToString(try? item.select(domValue("div.poster", key: "recently-id-1")).attr(domValue("data-tip", key: "recently-id-2")))
                let posterImage = castToString(try? item.select(domValue("img", key: "recently-poster-1")).attr(domValue("src", key: "recently-poster-2")))
                let enName = castToString(try? item.select(domValue("a.d-title", key: "recently-enName")).text())
                let jpName = castToString(try? item.select(domValue("a.d-title", key: "recently-jpName-1")).attr(domValue("data-jp", key: "recently-jpName-1")))
                let quality = castToString(try? item.select(domValue("div.meta > div.m-item", key: "recently-quality")).last()?.text())
                let sub = castToString(try? item.select(domValue("span.sub", key: "recently-sub")).text())
                let dub = castToString(try? item.select(domValue("span.dub", key: "recently-dub")).text())
                let eps = castToString(try? item.select(domValue("span.total", key: "recently-eps")).text())
                let type = castToString(try? item.select(domValue("div.right", key: "recently-type")).text())
                
                let detailLink = "\(baseUrl)\(castToString(try? item.select(domValue("div.poster > a", key: "recently-detail-1")).attr(domValue("href", key: "recently-detail-2"))))"
                
                var ani = AniModel(id: id,
                                   enName: enName,
                                   jpName: jpName,
                                   posterLink: posterImage,
                                   detailLink: detailLink,
                                   quality: quality,
                                   sub: sub,
                                   eps: eps)
                ani.dub = dub
                ani.type = type
                
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
            let list = try doc.select(domValue("ul.c4 > li > a[href*=/genre/]", key: "genre-list"))
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
        let link = "\(baseUrl)/home"
        
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([], [], [], [], [], [])
                return
            }
            
            completion(selfStrong.getTrending(doc),
                       selfStrong.getRecently(doc),
                       selfStrong.getTopItem(doc, .today),
                       selfStrong.getTopItem(doc, .week),
                       selfStrong.getTopItem(doc, .month),
                       selfStrong.getGenre(doc))
        }
    }
}

extension AnWHTMLService {
    func types() -> [AniGenreModel] {
        return [
            AniGenreModel(name: "TV Series", detailLink: "\(baseUrl)/tv", startColor: 0xA8C6FF, endColor: 0x4871E7),
            AniGenreModel(name: "Movies", detailLink: "\(baseUrl)/movie", startColor: 0x5285FE, endColor: 0xA74BFA),
            AniGenreModel(name: "OVAs", detailLink: "\(baseUrl)/ova", startColor: 0xFE52F0, endColor: 0xFA4BB2),
            AniGenreModel(name: "ONAs", detailLink: "\(baseUrl)/ona", startColor: 0xF9A432, endColor: 0xFAE24B),
            AniGenreModel(name: "Special", detailLink: "\(baseUrl)/special", startColor: 0x52EEFE, endColor: 0x0CC01A),
            AniGenreModel(name: "Music", detailLink: "\(baseUrl)/music", startColor: 0xed6ea0, endColor: 0xec8c69)
        ]
    }
    
    func genreDetail(page: Int, genre: AniGenreModel, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(genre.detailLink)?page=\(page)"
        
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([])
                return
            }
            
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
    
    func newest(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/newest?page=\(page)"
        
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([])
                return
            }
            
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
    
    func added(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/added?page=\(page)"
        
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([])
                return
            }
            
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
    
    func completed(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/completed?page=\(page)"
        
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([])
                return
            }
            
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
    
    func updated(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/updated?page=\(page)"
        
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([])
                return
            }
            
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
    
    func ongoing(page: Int, completion: @escaping (_ data: [AniModel]) -> Void) {
        let link = "\(baseUrl)/ongoing?page=\(page)"
        
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
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let finalURL = urlComponents.url else {
            completion([])
            return
        }
        
        self.fetchHTML(finalURL.absoluteString) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion([])
                return
            }
            
            let result = selfStrong.getBaseList(doc)
            completion(result)
        }
    }
    
}

extension AnWHTMLService {
    func detail(link: String, completion: @escaping (AniDetailModel?) -> Void) {
        self.loadingView.show()
        self.fetchHTML(link) { [weak self] html in
            guard let self = self, let _html = html, let doc = try? SwiftSoup.parse(_html) else {
                completion(nil)
                return
            }
            
            let id = castToString(try? doc.select(self.domValue("div#watch-main", key: "detail-id-1")).attr(self.domValue("data-id", key: "detail-id-2")))
            let posterLink = castToString(try? doc.select(self.domValue("img[itemprop*=image", key: "detail-poster-1")).first()?.attr(self.domValue("src", key: "detail-poster-2")))
            
            let enName = castToString(try? doc.select(self.domValue("h1[itemprop*=name", key: "detail-enName")).first()?.text())
            let jpName = castToString(try? doc.select(self.domValue("h1[itemprop*=name", key: "detail-jpName-1")).first()?.attr(self.domValue("data-jp", key: "detail-jpName-2")))
            let alias = ""
            let description = castToString(try? doc.select(self.domValue("div.synopsis > div.shorting > div.content", key: "detail-description")).text())
            var type = ""
            var studios = ""
            var dateAired = ""
            var status = ""
            var genres: [AniGenreModel] = []
            var scores = ""
            var premiered = ""
            var duration = ""
            let quality = ""
            let views = ""
            
            var suggestion: [AniModel]? = []
            let suggestionTmp = try? doc.select(self.domValue("div.scaff > a", key: "detail-suggestion-list")).array()
            for item in suggestionTmp ?? [] {
                let ssId = castToString(try? item.select(self.domValue("div.poster", key: "detail-suggestion-id-1")).attr(self.domValue("data-tip", key: "detail-suggestion-id-2")))
                let ssEnName = castToString(try? item.select(self.domValue("div.name", key: "detail-suggestion-enName")).text())
                let ssjpName = castToString(try? item.select(self.domValue("div.name", key: "detail-suggestion-jpName-1")).attr(self.domValue("data-jp", key: "detail-suggestion-jpName-2")))
                let ssPosterLink = castToString(try? item.select(self.domValue("img", key: "detail-suggestion-poster-1")).attr(self.domValue("src", key: "detail-suggestion-poster-2")))
                let ssDetailLink = "\(self.baseUrl)\(castToString(try? item.attr(self.domValue("href", key: "detail-suggestion-detaillink"))))"
                let ssType = castToString(try? item.select(self.domValue("div.meta > span", key: "detail-suggestion-type")).first()?.text())
                let ssView = castToString(try? item.select(self.domValue("div.meta > span", key: "detail-suggestion-view")).last()?.text())
                
                let sug = AniModel(id: ssId, enName: ssEnName, jpName: ssjpName,
                                   posterLink: ssPosterLink, detailLink: ssDetailLink,
                                   quality: "", sub: "", eps: "",
                                   view: ssView, type: ssType)
                
                if self.isAvailable(ssEnName) {
                    suggestion?.append(sug)
                }
            }
            
            var season: [AniSeasonModel] = []
            let seasonTmp = try? doc.select(self.domValue("div.season > a", key: "detail-season-list")).array()
            for item in seasonTmp ?? [] {
                let name = castToString(try? item.text())
                let detail = "\(self.baseUrl)\(castToString(try? item.attr(self.domValue("href", key: "detail-season-detailink"))))"
                var poster = castToString(try? item.attr(self.domValue("style", key: "detail-season-poster")))
                poster = self.firstMatch(for: "(https?://.*.(?:png|jpg))", in: poster) ?? ""
                
                season.append(AniSeasonModel(name: name, detailLink: detail, posterLink: poster))
            }
            
            let list = try? doc.select(self.domValue("div.bmeta > div.meta > div", key: "detail-season-meta")).array()
            for item in list ?? [] {
                let text = castToString(try? item.text())
                if text.starts(with: "Type:") {
                    type = text.replacingOccurrences(of: "Type:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if text.starts(with: "Studios:") {
                    studios = text.replacingOccurrences(of: "Studios:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if text.starts(with: "Date aired:") {
                    dateAired = text.replacingOccurrences(of: "Date aired:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if text.starts(with: "Status:") {
                    status = text.replacingOccurrences(of: "Status:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if text.starts(with: "MAL:") {
                    scores = text.replacingOccurrences(of: "MAL:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if text.starts(with: "Premiered:") {
                    premiered = text.replacingOccurrences(of: "Premiered:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if text.starts(with: "Duration:") {
                    duration = text.replacingOccurrences(of: "Duration:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if text.starts(with: "Genres:") {
                    let listGenre = try? item.select(self.domValue("a", key: "detail-season-meta-genre-list")).array()
                    for g in listGenre ?? [] {
                        genres.append(AniGenreModel(name: castToString(try? g.text()),
                                                    detailLink: "\(self.baseUrl)\(castToString(try? g.attr(self.domValue("href", key: "detail-season-genre"))))"))
                    }
                }
                
            }
            
            self.getEpisode(id: id) { episode in
                let ani = AniDetailModel(id: id, posterLink: posterLink, enName: enName,
                                         jpName: jpName, alias: alias, description: description,
                                         type: type, studios: studios, dateAired: dateAired,
                                         status: status, genres: genres, scores: scores,
                                         premiered: premiered, duration: duration,
                                         quality: quality, views: views, episode: episode,
                                         suggestion: suggestion, season: season)
                
                DispatchQueue.main.async {
                    completion(ani)
                    self.loadingView.dismiss()
                }
            }
            
        }
    }
    
    func getVrf(action: String, query: String, completion: @escaping (String?) -> Void) {
        let context = TaqJSContext()
        let _ = context?.evaluateScript(AltEnum.vrf.description())
        
        guard let jsFuncInit = context?.objectForKeyedSubscript("init"),
              let jsValue = jsFuncInit.call(withArguments: [action, query])
        else {
            completion(nil)
            return
        }
        
        if jsValue.isObject, let obj = jsValue.toDictionary() {
            TaqJSCore.shared.sendRequest(obj) { html, function in
                guard let param = html, let function = function else {
                    print("No Data")
                    completion(nil)
                    return
                }
                
                guard let jsFunc = context?.objectForKeyedSubscript(function),
                      let jsValue = jsFunc.call(withArguments: [param])
                else {
                    completion(nil)
                    return
                }
                
                completion(jsValue.toString())
            }
        }
    }
    
    func getEpisode(id: String, completion: @escaping ([AniEpisodesModel]) -> Void) {
        self.getVrf(action: "ajax-server-list", query: id) { vrf in
            guard let _vrf = vrf else {
                print("No Data")
                completion([])
                return
            }
            
            let context = TaqJSContext()
            let _ = context?.evaluateScript(AltEnum.episode.description())
            
            guard let jsFuncInit = context?.objectForKeyedSubscript("init"),
                  let jsValue = jsFuncInit.call(withArguments: [id, _vrf])
            else {
                completion([])
                return
            }
            
            if jsValue.isObject, let obj = jsValue.toDictionary() {
                TaqJSCore.shared.sendRequest(obj) { html, function in
                    guard let param = html, let function = function else {
                        print("No Data")
                        completion([])
                        return
                    }
                    
                    guard let jsFunc = context?.objectForKeyedSubscript(function),
                          let jsValue = jsFunc.call(withArguments: [param])
                    else {
                        completion([])
                        return
                    }
                    
                    var result: [AniEpisodesModel] = []
                    if jsValue.isString,
                       let ajHtml = jsValue.toString(),
                       let doc = try? SwiftSoup.parse(ajHtml)
                    {
                        do {
                            let list = try doc.select(self.domValue("div.episodes > ul > li > a", key: "detail-episode-list"))
                            for item in list {
                                let sourceID = castToString(try? item.attr(self.domValue("data-ids", key: "detail-episode-sourceId")))
                                let episode = castToString(try? item.attr(self.domValue("data-num", key: "detail-episode-num")))
                                let title = "Episode \(episode)"
                                let season = "1"
                                let epi = AniEpisodesModel(link: "",
                                                           sourceID: sourceID,
                                                           title: title,
                                                           season: season,
                                                           episode: episode)
                                result.append(epi)
                            }
                        } catch { }
                    }
                    
                    completion(result)
                }
            }
        }
    }
    
    func getServer(episodeId: String, completion: @escaping ([AniSerModel]) -> Void) {
        self.getVrf(action: "ajax-server", query: episodeId) { vrf in
            guard let _vrf = vrf else {
                print("No Data")
                completion([])
                return
            }
            
            let context = TaqJSContext()
            let _ = context?.evaluateScript(AltEnum.server.description())
            
            guard let jsFuncInit = context?.objectForKeyedSubscript("init"),
                  let jsValue = jsFuncInit.call(withArguments: [episodeId, _vrf])
            else {
                completion([])
                return
            }
            
            if jsValue.isObject, let obj = jsValue.toDictionary() {
                TaqJSCore.shared.sendRequest(obj) { html, function in
                    guard let param = html, let function = function else {
                        print("No Data")
                        completion([])
                        return
                    }
                    
                    guard let jsFunc = context?.objectForKeyedSubscript(function),
                          let jsValue = jsFunc.call(withArguments: [param])
                    else {
                        completion([])
                        return
                    }
                    
                    var result: [AniSerModel] = []
                    if jsValue.isString,
                       let ajHtml = jsValue.toString(),
                       let doc = try? SwiftSoup.parse(ajHtml)
                    {
                        do {
                            let divs = try doc.select(self.domValue("div.servers > div.type", key: "detail-server-list"))
                            for item in divs {
                                let type = castToString(try? item.attr(self.domValue("data-type", key: "detail-server-type")))
                                let listLI = try? item.select(self.domValue("ul > li", key: "detail-server-list-serv")).array()
                                for li in listLI ?? [] {
                                    let id = castToString(try? li.attr(self.domValue("data-link-id", key: "detail-server-link")))
                                    let name = castToString(try? li.text())
                                    let s = AniSerModel(id: id, name: name, type: type)
                                    result.append(s)
                                }
                            }
                        } catch { }
                    }
                    
                    completion(result)
                }
            }
        }
    }
    
    func getSource(serverId: String, completion: @escaping (AniSerDetailModel?) -> Void) {
        self.getVrf(action: "ajax-server", query: serverId) { vrf in
            guard let _vrf = vrf else {
                print("No Data")
                completion(nil)
                return
            }
            
            let context = TaqJSContext()
            let _ = context?.evaluateScript(AltEnum.source.description())
            
            guard let jsFuncInit = context?.objectForKeyedSubscript("init"),
                  let jsValue = jsFuncInit.call(withArguments: [serverId, _vrf])
            else {
                completion(nil)
                return
            }
            
            if jsValue.isObject, let obj = jsValue.toDictionary() {
                TaqJSCore.shared.sendRequest(obj) { html, function in
                    guard let param = html, let function = function else {
                        print("No Data")
                        completion(nil)
                        return
                    }
                    
                    guard let jsFunc = context?.objectForKeyedSubscript(function),
                          let jsValue = jsFunc.call(withArguments: [param])
                    else {
                        completion(nil)
                        return
                    }
                    
                    if jsValue.isObject, let json = jsValue.toDictionary() {
                        completion(AniSerDetailModel(url: (json["url"] as? String) ?? "",
                                                     skip_data: (json["skip_data"] as? String) ?? ""))
                    }
                    else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    
    func parsefilemoon(_ link: String, completion: @escaping (String?) -> Void) {
        self.fetchHTML(link) { [weak self] html in
            guard let selfStrong = self, let doc = selfStrong.document(html) else {
                completion(nil)
                return
            }
            
            do {
                var eval = ""
                let scripts = try doc.select("script")
                for sc in scripts {
                    if var ev = try? sc.html() {
                        ev = ev.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if ev.hasPrefix("eval") {
                            eval = ev
                            break
                        }
                    }
                }
                completion(eval)
            } catch {
                completion(nil)
            }
        }
        
    }
    
}
