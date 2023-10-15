//
//  Permission.swift
//  Tanqin
//
//  Created by HaKT on 12/10/2023.
//

import Foundation

extension UserDefaults {
    
    private struct Keys {
        static let hasBeenShowNoticeAccessCamera = "kHasBeenShowNoticeAccessCamera"
        static let hasBeenShowNoticeAccessPhoto = "kHasBeenShowNoticeAccessPhoto"
        static let hasBeenShowNoticeAccessMicro = "kHasBeenShowNoticeAccessMicro"
    }
    
    static var hasBeenShowNoticeAccessCamera: Bool {
        get { return standard.bool(forKey: Keys.hasBeenShowNoticeAccessCamera) }
        set { standard.set(newValue, forKey: Keys.hasBeenShowNoticeAccessCamera) }
    }
    
    static var hasBeenShowNoticeAccessPhoto: Bool {
        get { return standard.bool(forKey: Keys.hasBeenShowNoticeAccessPhoto) }
        set { standard.set(newValue, forKey: Keys.hasBeenShowNoticeAccessPhoto) }
    }
    
    static var hasBeenShowNoticeAccessMicro: Bool {
        get { return standard.bool(forKey: Keys.hasBeenShowNoticeAccessMicro) }
        set { standard.set(newValue, forKey: Keys.hasBeenShowNoticeAccessMicro) }
    }
}
