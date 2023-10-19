//
//  MainTabbaController.swift
//  Tanqin
//
//  Created by HaKT on 05/10/2023.
//

import UIKit


class MainTabbaController: UITabBarController {
    
    enum TabbarEnum {
        case quoteOfDay
        case animeQuote
        case fanArt
        case short
        
        var title: String? {
            switch self {
            case .quoteOfDay:
                return "Quote of day"
            case .animeQuote:
                return "Anime quote"
            case .fanArt:
                return "Wallpaper"
            default:
                return "Short"
            }
        }
        var iconSelected: UIImage? {
            switch self {
            case .quoteOfDay:
                return .ic_quote_of_day_selected
            case .animeQuote:
                return .ic_anime_quote_selected
            case .fanArt:
                return .ic_fan_art_selected
            default:
                return .ic_short_selected
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .quoteOfDay:
                return .ic_quote_of_day
            case .animeQuote:
                return .ic_anime_quote
            case .fanArt:
                return .ic_fan_art
            default:
                return .ic_short
            }
        }
    }
    
    //MARK: - Property
    let enumItems: [TabbarEnum] = [.quoteOfDay, .animeQuote, .fanArt, .short]
    var moveSpace: CGFloat = 35
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        moveSpace = tabBar.frame.height / 2
        loadViewIfNeeded()
    }
    
    //MARK: - Private
    private func setUpUI() {
        
        let quoteOfDayVC = addController(QuoteOfDayViewController(), .quoteOfDay) as! QuoteOfDayViewController
        let quoteOfDayVM = QuoteOfDayViewModel(useCase: QuoteOfDayUseCase())
        quoteOfDayVC.viewModel = quoteOfDayVM
        
        let quoteVC = addController(AnimeQuoteViewController(), .animeQuote) as! AnimeQuoteViewController
        let quoteVM = AnimeQuoteViewModel(useCase: AnimeQuoteUseCase())
        quoteVC.viewModel = quoteVM
        
        let artVC = addController(FanArtViewController(), .fanArt) as! FanArtViewController
        let artVM = FanArtViewModel(useCase: FanArtUseCase())
        artVC.viewModel = artVM
        
        let shortVC = addController(ShortViewController(), .short) as! ShortViewController
        let shortVM = ShortViewModel(useCase: ShortUseCase())
        shortVC.viewModel = shortVM
        
        viewControllers = [quoteOfDayVC, quoteVC, artVC, shortVC]
        self.delegate = self

        tabBar.backgroundColor = .tabbarColor
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .white
        
        selectedIndex = 0
    }
    
    private func addController(_ controller: UIViewController,_ caseItem: TabbarEnum) -> UIViewController {
        let item = UITabBarItem(title: nil, image: caseItem.icon, selectedImage: caseItem.iconSelected?.withRenderingMode(.alwaysOriginal))
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.balooBhaina2_SemiBold(ofSize: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold), // Set your desired font size
            .foregroundColor: UIColor.white // Set your desired text color
        ]
        item.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        if caseItem == .quoteOfDay {
            item.title = caseItem.title
            item.imageInsets = UIEdgeInsets(top: -moveSpace, left: 0, bottom: 0, right: 0)
        }
        
        controller.tabBarItem = item
        
        return controller
    }
}

//MARK: - Extension UITabBarControllerDelegate
extension MainTabbaController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.selectedIndex
        guard let items = tabBarController.tabBar.items else {
            return
        }
        
        for (index, item) in items.enumerated() {
            if index == selectedIndex {
                item.title = enumItems[index].title
                item.imageInsets = UIEdgeInsets(top: -moveSpace, left: 0, bottom: 0, right: 0)
            } else {
                item.title = nil
                item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
}
