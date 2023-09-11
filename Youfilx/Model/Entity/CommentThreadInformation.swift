//
//  CommentThreadInformation.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/08.
//

import Foundation

struct CommentThreadInformation: Hashable {
    let id: String
    let channelId: String
    let videoId: String?
    let textDisplay: String
    let authorDisplayName: String
    let authorProfileImageUrl: String
    let authorChannelId: String
    let likeCount: Int
    let totalReplyCount: Int
}
