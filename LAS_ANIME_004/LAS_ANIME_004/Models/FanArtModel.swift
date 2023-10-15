//
//  FanArtModel.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 09/10/2023.
//

import Foundation

struct FanArtModel: Codable {
    let status: String
    let tag: String
    let data: [FanArtDataModel]
}

struct FanArtDataModel: Codable {
    let categoryId: Int?
    let id: Int?
    let username: String?
    let fullName: String?
    let avatar: String?
//    let video: String?
    let image: String?
    let postDate: String?
    let likes: Int?
    let comment: Int?
    let totalRepost: Int?
    let isLiked: Bool?
    let isRepost: Int?
//    let commentPreview: CommentPreviewModel?
}

struct CommentPreviewModel: Codable {
    let id: Int
    let image: String?
    let avatar: String
    let fullName: String
    let username: String
    let postDate: String
    let commentTxt: String
}
