//
//  CommentsListResponse.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/06.
//

import Foundation

struct CommentListResponse: Decodable {
    let kind: String
    let etag: String
    let nextPageToken: String
    let items: [CommentListThread]
    let pageInfo: CommetListPageInfo
    
    struct CommetListPageInfo: Decodable {
        let resultsPerPage: Int
    }
    
    struct CommentListThread: Decodable {
        let kind: String
        let etag: String
        let id: String
        let snippet: Snippet
        
        struct Snippet: Decodable {
            let channelId: String
            let parentId: String
            let textDisplay: String
            let textOriginal: String
            let authorDisplayName: String
            let authorProfileImageUrl: String
            let authorChannelUrl: String
            let authorChannelId: AuthorChannelId
            let canRate: Bool
            let viewerRating: String
            let likeCount: Int
            let publishedAt: String
            let updatedAt: String
            
            struct AuthorChannelId: Decodable {
                let value: String
            }
            
        }
        
    }
    
    func toCommentThreadInformations() -> [CommentThreadInformation]? {
        if items.count == 0 {
            return nil
        }
        return items.map { item in
            let snippet = item.snippet
            return CommentThreadInformation(
                id: item.id,
                channelId: snippet.channelId,
                videoId: snippet.channelId,
                textDisplay: snippet.textDisplay,
                authorDisplayName: snippet.authorDisplayName,
                authorProfileImageUrl: snippet.authorProfileImageUrl,
                authorChannelId: snippet.authorChannelId.value,
                likeCount: snippet.likeCount,
                totalReplyCount: 0
            )
        }
    }

}

