//
//  AnimeQuoteModel.swift
//  Tanqin
//
//  Created by HaKT on 28/09/2023.
//

import Foundation

struct AnimeQuoteModel: Codable {
    let data: [AnimeQuoteDayModel]
}

struct AnimeQuoteDayModel: Codable {
    let id: String
    let quoteId: Int
    let username: String
    let avatar: String
    let animeName: String
    let animeCharacter: String
    let quote: String
    let quoteURL: String
    let v: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case quoteId = "quote_id"
        case username = "username"
        case avatar = "avatar"
        case animeName = "animename"
        case animeCharacter = "anime_character"
        case quote = "quotes"
        case quoteURL = "quoteurl"
        case v = "v"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}
