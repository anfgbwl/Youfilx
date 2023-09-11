//
//  CommentThreadResponse.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/06.
//

import Foundation

struct CommentThreadResponse: Decodable {
    let kind: String?
    let etag: String?
    let nextPageToken: String
    let pageInfo: PageInfo
    
    let items: [CommentThread]
    
    struct PageInfo: Decodable {
        let totalResults: Int
        let resultsPerPage: Int
    }
    
    struct CommentThread: Decodable {
        let kind: String?
        let etag: String?
        let id: String
        let snippet: Snippet
        
        struct Snippet: Decodable {
            let channelId: String
            let videoId: String
            let topLevelComment: TopLevelComment
            let canReply: Bool
            let totalReplyCount: Int
            let isPublic: Bool
        }
        
        struct TopLevelComment: Decodable {
            let kind: String
            let etag: String
            let id: String
            let snippet: CommentItemSnippet
            
            struct CommentItemSnippet: Decodable {
                let channelId: String
                let videoId: String
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
    }
    
    func toCommentThreadInformations() -> [CommentThreadInformation]? {
        if items.count == 0 {
            return nil
        }
        return items.map { item in
            let snippet = item.snippet
            let topCommentSnippet = snippet.topLevelComment.snippet
            return CommentThreadInformation(
                id: snippet.topLevelComment.id,
                channelId: snippet.channelId,
                videoId: snippet.videoId,
                textDisplay: topCommentSnippet.textDisplay,
                authorDisplayName: topCommentSnippet.authorDisplayName,
                authorProfileImageUrl: topCommentSnippet.authorProfileImageUrl,
                authorChannelId: topCommentSnippet.authorChannelId.value,
                likeCount: topCommentSnippet.likeCount,
                totalReplyCount: snippet.totalReplyCount
            )
        }
    }
    
}
