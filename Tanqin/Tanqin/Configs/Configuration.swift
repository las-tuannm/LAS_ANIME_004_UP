//
//  Configurations.swift
//  Tanqin
//
//  Created by HaKT on 11/10/2023.
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
