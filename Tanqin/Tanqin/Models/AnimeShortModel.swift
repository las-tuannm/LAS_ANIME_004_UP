//
//  AnimeShortModel.swift
//  Tanqin
//
//  Created by HaKT on 02/10/2023.
//

import Foundation

struct AnimeShortsModel: Codable {
    let data : [AnimeShortModel]
}

struct AnimeShortModel: Codable {
    let _id: String
    let id: Int
    let username: String
    let avatar: String
    let fullName: String
    let postTxt: String
    let postDate: String
    let postImg: String?
    let video: String
    let v: Int
    let createdAt: String
    let updatedAt: String
}
