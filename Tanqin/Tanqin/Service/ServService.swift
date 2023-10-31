import UIKit

class ServService: NSObject {
    
    // MARK: - properties
    fileprivate var link: String = ""
    fileprivate var name: String = ""
    fileprivate var season: String = ""
    fileprivate var episode: String = ""
    fileprivate var sourceId: String = ""
    fileprivate var sers: [AniSerModel] = []
    fileprivate var sersRequested: [AniSerModel] = []
    
    // MARK: - initial
    static let shared = ServService()
    
    override init() { }
    
    // MARK: - private
    
    // MARK: - public
    func fetchServer(link: String, name: String, season: String,
                     episode: String, sourceId: String,
                     completion: @escaping ([TaqiDictionary]) -> Void)
    {
        self.link = link
        self.name = name
        self.season = season
        self.episode = episode
        self.sourceId = sourceId
        self.sers.removeAll()
        self.sersRequested.removeAll()
        
        AnWHTMLService.shared.getServer(episodeId: sourceId) { [weak self] sers in
            guard let self = self else {
                completion([])
                return
            }
            
            self.sers = sers
            self.sersRequested.removeAll()
            self.fetchNextSourceIfAvailable(completion: completion)
        }
    }
    
    func fetchNextSourceIfAvailable(completion: @escaping ([TaqiDictionary]) -> Void) {
        if self.sers.count == 0 {
            completion([])
            return
        }
        
        let fi = self.sers.remove(at: 0)    // remove
        self.sersRequested.append(fi)       // add
        
        AnWHTMLService.shared.getSource(serverId: fi.id) { [weak self] serDetail in
            guard let self = self, let dt = serDetail else {
                completion([])
                return
            }
            
            if fi.name.lowercased().contains("filemoon") {
                NetworksService.shared.loadInfoFilemoon(link: dt.url) { data in
                    guard let dic = data, let link = dic["url"] as? String else {
                        if self.sers.count > 0 {
                            self.fetchNextSourceIfAvailable(completion: completion)
                        }
                        return
                    }
                    
                    AnWHTMLService.shared.parsefilemoon(link) { eval in
                        guard let evl = eval else {
                            if self.sers.count > 0 {
                                self.fetchNextSourceIfAvailable(completion: completion)
                            }
                            return
                        }
                        
                        NetworksService.shared.upaFilemoon(eval: evl, type: fi.type) { dataFinal in
                            completion(dataFinal)
                        }
                    }
                }
            }
            else {
                NetworksService.shared.loadInfoawvs(title: self.name, season: self.season, episode: self.episode, type: fi.type, extractor: fi.name, link: dt.url) { data in
                    
                    if data.count == 0 {
                        if self.sers.count > 0 {
                            self.fetchNextSourceIfAvailable(completion: completion)
                        }
                        else {
                            // alert not found link here
                            completion([])
                        }
                        return
                    }
                    
                    completion(data)
                }
            }
        }
    }
}
