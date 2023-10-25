//
//  AppDelegate.swift
//  Tanqin
//
//  Created by HaKT on 05/10/2023.
//

import UIKit
import AppLovinSDK
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var observer: Any?
    var window: UIWindow?
    
    private func requestTrackingAuthorization(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { [weak self] _ in
                
                guard let self = self else { return }
                
                ATTrackingManager.requestTrackingAuthorization { _ in
                    DispatchQueue.main.async { completion() }
                }
                
                self.observer.flatMap {
                    NotificationCenter.default.removeObserver($0)
                }
            })
        }
        else {
            completion()
        }
    }
    
    private func awakeAds() {
        AdmobController.shared.awake {
            AdmobOpenController.shared.awake()
        }
        ApplovinController.shared.awake {
            ApplovinOpenController.shared.awake()
        }
    }
    
    private func loadGthub() {
        guard let url = URL(string: AppInfo.gthub) else {
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _data = data else { return }
            
            do {
                let json = (try JSONSerialization.jsonObject(with: _data, options: []) as? [String: Any]) ?? [:]
                for (key, value) in json {
                    UserDefaults.standard.set(value, forKey: key)
                }
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name("loadedGtHub"), object: nil)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        loadGthub()
        requestTrackingAuthorization { [weak self] in
            self?.awakeAds()
        }
        
        if #available(iOS 13.0, *) {
            // SceneDelegate.swift will config
        }
        else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = SplashController()
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let root = UIWindow.keyWindow?.topMost else {
            return
        }
        
        if root is SplashController {
            return
        }
        
        if !AdmobOpenController.shared.tryToPresent() {
            ApplovinOpenController.shared.tryToPresent()
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

