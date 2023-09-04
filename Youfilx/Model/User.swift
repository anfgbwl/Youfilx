//
//  User.swift
//  Youfilx
//
//  Created by t2023-m0076 on 2023/09/04.
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
