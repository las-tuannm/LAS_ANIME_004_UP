import UIKit
import Countly
import AppTrackingTransparency

class TabBarVC: UITabBarController {
    
    private var firstDisplayed: Bool = false
    var genres: [AniGenreModel] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarView()
        setupViewControllers()
        
        let event = ["source" :  HTMLService.shared.getSourceAnime().getTitleSource()]
        Countly.sharedInstance().recordEvent("source", segmentation:event)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !firstDisplayed && hasRequestTrackingIDFA() {
            firstDisplayed = true
            
            if let id = GlobalDataModel.shared.rev?.appid, let message = GlobalDataModel.shared.rev?.message {
                ApplicationHelper.shared.presentAlertInstall(appid: id, message: message) {
                    if GlobalDataModel.shared.isRating {
                        ApplicationHelper.shared.presentRateApp()
                    }
                }
            }
            else if GlobalDataModel.shared.isRating {
                ApplicationHelper.shared.presentRateApp()
            }
        }
    }
    
    private func hasRequestTrackingIDFA() -> Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus != .notDetermined
        }
        else {
            return true
        }
    }
    
    private func setupTabbarView() {
        let backgroundTabbar = UIColor(rgb: 0x0F1017)
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundTabbar
            
            tabBar.standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            UITabBar.appearance().backgroundColor = backgroundTabbar
            tabBar.backgroundImage = UIImage()
        }
    }
    
    private func setupViewControllers() {
        let home = HomeVC()
        home.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "ic-tab-home")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "ic-tab-home-active")?.withRenderingMode(.alwaysOriginal))
        home.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        let popular = PopularVC()
        popular.tabBarItem = UITabBarItem(title: nil,
                                          image: UIImage(named: "ic-tab-library")?.withRenderingMode(.alwaysOriginal),
                                          selectedImage: UIImage(named: "ic-tab-library-active")?.withRenderingMode(.alwaysOriginal))
        popular.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        let search = SearchVC()
        search.tabBarItem = UITabBarItem(title: nil,
                                         image: UIImage(named: "ic-tab-search")?.withRenderingMode(.alwaysOriginal),
                                         selectedImage: UIImage(named: "ic-tab-search-active")?.withRenderingMode(.alwaysOriginal))
        search.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        let setting = SettingVC()
        setting.tabBarItem = UITabBarItem(title: nil,
                                          image: UIImage(named: "ic-tab-setting")?.withRenderingMode(.alwaysOriginal),
                                          selectedImage: UIImage(named: "ic-tab-setting-active")?.withRenderingMode(.alwaysOriginal))
        setting.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        self.viewControllers = [home, popular, search, setting]
    }
}
