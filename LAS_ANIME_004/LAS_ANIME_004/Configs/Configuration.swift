//
//  Configurations.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 11/10/2023.
//

import Foundation

enum Configuration {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let googleAPIKey: String = {
        guard let string = Configuration.infoDictionary["GoogleAPIKey"] as? String else {
            fatalError("Google API key not set in plist for this environment")
        }
        return string
    }()
}
