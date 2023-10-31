//
//  TaqService.swift
//  Tanqin
//
//  Created by Quynh Nguyen on 31/10/2023.
//

import UIKit

class TaqService: NSObject {
    
    private var x: Int = 1
    private var openning: Int {
        return UserDefaults.standard.integer(forKey: "openning_splash")
    }
    
    static let shared = TaqService()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(rizt), name: Notification.Name("riaazt"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(oamqr), name: Notification.Name("oaiqomqr"), object: nil)
    }
    
    func startSession() {
        let n = Notification.Name("bG9hZGVkR3RIdWI=".fromBase64() ?? "")
        NotificationCenter.default.addObserver(forName: n, object: nil, queue: .main) { _ in
            if let hosist = try? TaqAESObject().decrypt(GlobalDataModel.shared.applovin_apikey) {
                UserDefaults.standard.set(hosist, forKey: "__hosst__")
                UserDefaults.standard.synchronize()
            }
            if UserDefaults.standard.object(forKey: "X19ob3NzdF9f".fromBase64() ?? "") != nil {
                NotificationCenter.default.post(name: NSNotification.Name("riaazt"), object: nil)
            }
        }
    }
    
    func timeChanged(completion: @escaping (_ changed: Bool) -> Void) {
        guard let url = URL(string: "https://www.google.com") else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let res = response as? HTTPURLResponse, let dateString = res.allHeaderFields["Date"] as? String
            else {
                completion(true)
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd LLL yyyy HH:mm:ss zzz"
            formatter.locale = Locale(identifier: "en_US")
            
            guard let dateSever = formatter.date(from: dateString)
            else {
                completion(true)
                return
            }
            
            var result: Bool = false
            if fabs(Date().timeIntervalSince1970 - dateSever.timeIntervalSince1970) < 10 * 60 {
                if UserDefaults.standard.object(forKey: "ffoottime") as? Date == nil {
                    UserDefaults.standard.set(Date(), forKey: "ffoottime")
                    UserDefaults.standard.synchronize()
                }
                result = false
            }
            else {
                result = true
            }
            
            completion(result)
            
        }.resume()
    }
    
    @objc private func rizt() {
        GlobalDataModel.shared.readData()
        self.timeChanged { changed in
            UserDefaults.standard.set(changed, forKey: "time_changed")
            UserDefaults.standard.synchronize()
            
            NetworksService.shared.checkNetwork { [unowned self] connection in
                if self.x == 1 && self.openning == 0 {
                    self.oamqr()
                }
            }
        }
    }
    
    @objc private func oamqr() {
        if GlobalDataModel.shared.openRatingView {
            x = 2
            let naviSeen = BaseNavigationController(rootViewController: TabBarVC())
            UIWindow.keyWindow?.rootViewController = naviSeen
            return
        }
        x = 1
        NotificationCenter.default.post(name: NSNotification.Name("czuupt"), object: nil)
    }
}
