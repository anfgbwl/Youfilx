//
//  Video.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import Foundation

struct Video: Codable {
    let id: String
    let thumbnailImage: String
    let title: String
    let creatorNickname: String
    let views: Int
    let duration: String
    let uploadDate: Date
    var comments: [Comment]
}
