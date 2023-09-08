//
//  Video.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import Foundation

struct Video: Codable {
    var id: String = ""
    var thumbnailImage: String = ""
    var title: String = ""
    var creatorNickname: String = ""
    var views: Int = 0
    var duration: String = ""
    var uploadDate: Date = .init()
    var comments: [Comment] = []
    var currentTime: Int?
}
