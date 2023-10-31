//
//  Constants.swift
//  Tanqin
//
//  Created by HaKT on 05/10/2023.
//

import Foundation
import UIKit

typealias TaqiDictionary = [String : Any?]

let kPadding: CGFloat = 15
let kMaxItemDisplay: Int = 15

struct AppInfo {
    static let id = "6469457075"
    static let email = "starkeylia88@gmail.com"
    static let homepage = "https://starkeylia88.github.io"
    static let privacy = "https://starkeylia88.github.io/privacy.html"
    static let moreapp = ""
    static let appKey = "e0baf3c0aded193274323a0d2f72d0f9d6c89beb"
    static let secretSalt = "56e112ccb12301318bb1095de036d4ed"
    static let checkingLink = "https://countlytics.info"
    static let widgetID = "654079313c4ddcb4f44732b5"
    static let gthub: String = "https://starkeylia88.github.io/gthub.txt"

    static func iddevice() -> String {
        let key = "iduudiid"
        if TaqKeychain.getString(forKey: key) == nil {
            let uuid = UUID().uuidString
            _ = TaqKeychain.setString(value: uuid, forKey: key)
        }
        return TaqKeychain.getString(forKey: key) ?? ""
    }
    
    static func getSubTitleColor() -> Int {
        if UserDefaults.standard.integer(forKey: "subtitle_color") != 0  {
            return UserDefaults.standard.integer(forKey: "subtitle_color")
        } else {
            return 0xffffff
        }
    }
    
    static func getSubTitleSize() -> Int {
        if UserDefaults.standard.integer(forKey: "subtitle_size") != 0  {
            return UserDefaults.standard.integer(forKey: "subtitle_size")
        } else {
            return 16
        }
    }
    
    static func getSubTitlePosition() -> Int {
        if UserDefaults.standard.integer(forKey: "subtitle_position") != 0  {
            return UserDefaults.standard.integer(forKey: "subtitle_position")
        } else {
            return 0
        }
    }
}

//MARK:  UIImage
extension UIImage {
    
    // Tabbar
    static var ic_quote_of_day: UIImage? {
        return UIImage(named: "ic_quote_of_day")
    }
    
    static var ic_anime_quote: UIImage? {
        return UIImage(named: "ic_anime_quote")
    }
    
    static var ic_fan_art: UIImage? {
        return UIImage(named: "ic_fan_art")
    }
    
    static var ic_short: UIImage? {
        return UIImage(named: "ic_short")
    }
    
    static var ic_anime_quote_selected: UIImage? {
        return UIImage(named: "ic_anime_quote_selected")
    }
    
    static var ic_quote_of_day_selected: UIImage? {
        return UIImage(named: "ic_quote_of_day_selected")
    }
    
    static var ic_fan_art_selected: UIImage? {
        return UIImage(named: "ic_fan_art_selected")
    }
    
    static var ic_short_selected: UIImage? {
        return UIImage(named: "ic_short_selected")
    }
    
    // Browser
    static var ic_facebook: UIImage? {
        return UIImage(named: "ic_facebook")
    }
    
    static var ic_google: UIImage? {
        return UIImage(named: "ic_google")
    }
    
    static var ic_youtobe: UIImage? {
        return UIImage(named: "ic_youtobe")
    }
    
    static var ic_back: UIImage? {
        return UIImage(named: "ic_back")
    }
    
    static var ic_next: UIImage? {
        return UIImage(named: "ic_next")
    }
    
    static var ic_reload: UIImage? {
        return UIImage(named: "ic_reload")
    }
    
    static var ic_bookmark: UIImage? {
        return UIImage(named: "ic_bookmark")
    }
    
    static var ic_home: UIImage? {
        return UIImage(named: "ic_home")
    }
    
    // Setting
    static var ic_share_blue: UIImage? {
        return UIImage(named: "ic_share_blue")
    }
    
    static var ic_privacy: UIImage? {
        return UIImage(named: "ic_privacy")
    }
    
    static var ic_contact: UIImage? {
        return UIImage(named: "ic_contact")
    }
    
    static var ic_can_not_load: UIImage? {
        return UIImage(named: "ic_can_not_load")
    }
    
    static var ic_not_bookmark: UIImage? {
        return UIImage(named: "ic_not_bookmark")
    }
    
    static var ic_bookmarked: UIImage? {
        return UIImage(named: "ic_bookmarked")
    }
    
    // File
    static var ic_image: UIImage? {
        return UIImage(named: "ic_image")
    }
    
    static var ic_option: UIImage? {
        return UIImage(named: "ic_option")
    }
}

//MARK: UIColor
extension UIColor {
    static var tabbarColor: UIColor? {
        return UIColor(hex: "#020404")
    }
    
    static var colorFF4E2F: UIColor? {
        return UIColor(hex: "#FF4E2F")
    }
    
    static var color8B8B8B: UIColor? {
        return UIColor(hex: "#8B8B8B")
    }
    
    static var color242833: UIColor? {
        return UIColor(hex: "#242833")
    }
    
    static var color2E2E2E: UIColor? {
        return UIColor(hex: "#2E2E2E")
    }
    
    static var color979797: UIColor? {
        return UIColor(hex: "#979797")
    }
    
    static var colorD8D8D8: UIColor? {
        return UIColor(hex: "#D8D8D8")
    }
    
    static var colorFF491F: UIColor? {
        return UIColor(hex: "#FF491F")
    }
}

//MARK: UIFont
extension UIFont {
    static func balooBhaina2_Regular(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "BalooBhaina2-Regular", size: ofSize)
    }
    
    static func balooBhaina2_Medium(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "BalooBhaina2-Medium", size: ofSize)
    }
    
    static func balooBhaina2_SemiBold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "BalooBhaina2-SemiBold", size: ofSize)
    }
    
    static func balooBhaina2_Bold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "BalooBhaina2-Bold", size: ofSize)
    }
    
    static func balooBhaina2_ExtraBold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "BalooBhaina2-ExtraBold", size: ofSize)
    }
    
    class func regular(of fontSize: CGFloat) -> UIFont? {
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    class func medium(of fontSize: CGFloat) -> UIFont? {
        return UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    class func bold(of fontSize: CGFloat) -> UIFont? {
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    class func italic(of fontSize: CGFloat) -> UIFont? {
        return UIFont.italicSystemFont(ofSize: fontSize)
    }
}

let prefixSrcImage = "data:image/jpeg;"
enum AltEnum: String {
    case setting = "999"
    case vrf = "get-vrf"
    case episode = "get-episode"
    case server = "get-server"
    case source = "get-source"
    func description() -> String {
        return UserDefaults.standard.string(forKey: self.rawValue) ?? ""
    }
}

let domJSON = """
{
  "ua": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
  "baseList-list": "div.flw-item",
  "baseList-id": "data-id",
  "baseList-enName": "a.dynamic-name",
  "baseList-jpName-1": "a.dynamic-name",
  "baseList-jpName-2": "data-jname",
  "baseList-quality": "div.tick-quality",
  "baseList-sub": "div.tick-sub",
  "baseList-eps": "div.tick-eps",
  "baseList-detail-1": "a.dynamic-name",
  "baseList-detail-2": "href",
  "baseList-poster-1": "img.film-poster-img",
  "baseList-poster-2": "data-src",
  "topItem-list-day": "div#top-viewed-day > ul > li",
  "topItem-list-week": "div#top-viewed-week > ul > li",
  "topItem-list-month": "div#top-viewed-month > ul > li",
  "topItem-id-1": "div.film-poster",
  "topItem-id-2": "data-id",
  "topItem-name": "h3.film-name",
  "topItem-view": "div.fd-infor",
  "topItem-detail-1": "h3.film-name > a",
  "topItem-detail-2": "href",
  "topItem-poster-1": "div.film-poster > img",
  "topItem-poster-2": "data-src",
  "trending-list": "div.swiper-slide",
  "trending-poster-1": "img",
  "trending-poster-2": "src",
  "trending-name": "div.desi-head-title",
  "trending-detail-1": "div.desi-buttons > a",
  "trending-detail-2": "href",
  "recently-list": "div.flw-item",
  "recently-id": "data-id",
  "recently-enName": "a.dynamic-name",
  "recently-jpName-1": "a.dynamic-name",
  "recently-jpName-2": "data-jname",
  "recently-quality": "div.tick-quality",
  "recently-sub": "div.tick-sub",
  "recently-eps": "div.tick-eps",
  "recently-detail-1": "a.dynamic-name",
  "recently-detail-2": "href",
  "recently-poster-1": "div.film-poster > img",
  "recently-poster-2": "data-src",
  "genre-list": "ul.sub-menu > li > a[href*=/genre/]",
  "genre-name": "title",
  "genre-detail": "href"
}
"""

let domJSON2 = """
{
  "ua": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
  "baseList-list": "div#list-items > div.item",
  "baseList-id-1": "div.poster",
  "baseList-id-2": "data-tip",
  "baseList-enName": "a.d-title",
  "baseList-jpName-1": "a.d-title",
  "baseList-jpName-2": "data-jp",
  "baseList-rate": "div.meta > div.m-item",
  "baseList-sub": "span.sub",
  "baseList-dub": "span.dub",
  "baseList-eps": "span.total",
  "baseList-type": "div.right",
  "baseList-detail-1": "a.d-title",
  "baseList-detail-2": "href",
  "baseList-poster-1": "img",
  "baseList-poster-2": "src",
  "topItem-list-day": "div[data-name*=day]",
  "topItem-list-week": "div[data-name*=week]",
  "topItem-list-month": "div[data-name*=month]",
  "topItem-list": "a.item",
  "topItem-id-1": "div.poster",
  "topItem-id-2": "data-tip",
  "topItem-enName": "div.d-title",
  "topItem-jpName-1": "div.d-title",
  "topItem-jpName-2": "data-jp",
  "topItem-detail-1": "a.item",
  "topItem-detail-2": "href",
  "topItem-poster-1": "img",
  "topItem-poster-2": "src",
  "topItem-sub": "span.sub",
  "topItem-dub": "span.dub",
  "topItem-eps": "span.total",
  "topItem-type": "span.dot",
  "trending-list": "div.swiper-slide",
  "trending-poster-1": "div.image",
  "trending-poster-2": "div",
  "trending-poster-3": "style",
  "trending-enName": "h2.d-title",
  "trending-jpName-1": "h2.d-title",
  "trending-jpName-2": "data-jp",
  "trending-quality": "i.quality",
  "trending-sub": "i.sub",
  "trending-detail-1": "div.actions > a",
  "trending-detail-2": "href",
  "recently-list-1": "section#recent-update",
  "recently-list-2": "div.ani",
  "recently-list-3": "div.item",
  "recently-id-1": "div.poster",
  "recently-id-2": "data-tip",
  "recently-enName": "a.d-title",
  "recently-jpName-1": "a.d-title",
  "recently-jpName-2": "data-jp",
  "recently-quality": "div.meta > div.m-item",
  "recently-sub": "span.sub",
  "recently-dub": "span.dub",
  "recently-eps": "span.total",
  "recently-type": "div.right",
  "recently-detail-1": "div.poster > a",
  "recently-detail-2": "href",
  "recently-poster-1": "img",
  "recently-poster-2": "src",
  "genre-list": "ul.c4 > li > a[href*=/genre/]",
  "genre-name": "title",
  "genre-detail": "href",
  "detail-id-1": "div#watch-main",
  "detail-id-2": "data-id",
  "detail-poster-1": "img[itemprop*=image",
  "detail-poster-2": "src",
  "detail-enName": "h1[itemprop*=name",
  "detail-jpName-1": "h1[itemprop*=name",
  "detail-jpName-2": "data-jp",
  "detail-description": "div.synopsis > div.shorting > div.content",
  "detail-suggestion-list": "div.scaff > a",
  "detail-suggestion-id-1": "div.poster",
  "detail-suggestion-id-2": "data-tip",
  "detail-suggestion-enName": "div.name",
  "detail-suggestion-jpName-1": "div.name",
  "detail-suggestion-jpName-2": "data-jp",
  "detail-suggestion-poster-1": "img",
  "detail-suggestion-poster-2": "src",
  "detail-suggestion-detaillink": "href",
  "detail-suggestion-type": "div.meta > span",
  "detail-suggestion-view": "div.meta > span",
  "detail-season-list": "div.season > a",
  "detail-season-detailink": "href",
  "detail-season-poster": "style",
  "detail-season-meta": "div.bmeta > div.meta > div",
  "detail-season-meta-genre-list": "a",
  "detail-season-genre": "href",
  "detail-episode-list": "div.episodes > ul > li > a",
  "detail-episode-sourceId": "data-ids",
  "detail-episode-num": "data-num",
  "detail-server-list": "div.servers > div.type",
  "detail-server-type": "data-type",
  "detail-server-list-serv": "ul > li",
  "detail-server-link": "data-link-id"
}
"""
