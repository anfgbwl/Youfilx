//
//  User.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import Foundation

struct User {
    let id: String
    let password: String
    let nickname: String
    var image: Data?
    var watchHistory: [Video]
    var favoriteVideos: [Video]
}
