//
//  VideoInformationSearchResponse.swift
//  Youfilx
//
//  Created by hong on 2023/09/06.
//

import Foundation

struct VideoInformationSearchResponse: Decodable {
    let kind: String?
    let etag: String?
    let items: [VideoItem]
    let pageInfo: PageInfo
    
    struct PageInfo: Decodable {
        let totalResults: Int
        let resultsPerPage: Int
    }
    
    struct VideoItem: Decodable {
        let kind: String?
        let etag: String?
        let id: String
        let snippet: Snippet
        let contentDetails: ContentDetails
        let statistics: Statistics
        
        struct Snippet: Decodable {
            let publishedAt: String
            let channelId: String
            let title: String
            let description: String
            let thumbnails: ThumbnailImages
            let channelTitle: String
            let tags: [String]?
            let categoryId: String
            let liveBroadcastContent: String
            let localized: Localized
//            let defaultAudioLanguage: String
            
            struct ThumbnailImages: Decodable {
                let `default`: Thumbnail
                let medium: Thumbnail
                let high: Thumbnail
                let standard: Thumbnail
                let maxres: Thumbnail
                
                struct Thumbnail: Decodable {
                    let url: String
                    let width: Int
                    let height: Int
                }

            }
            
            struct Localized: Decodable {
                let title: String
                let description: String
            }
        }
        
        struct ContentDetails: Decodable {
            let duration: String
            let dimension: String
            let definition: String
            let caption: String
            let licensedContent: Bool
            let projection: String
        }
        
        struct Statistics: Decodable {
            let viewCount: String
            let likeCount: String
            let favoriteCount: String
            let commentCount: String
        }

    }
    
    func toVideoInformation() -> VideoInformation? {
        if items.count == 0 {
            return nil
        }
        let item = items[0]
        let snippet = item.snippet
        let statics = item.statistics
        return VideoInformation(
            title: snippet.title,
            createdAt: snippet.publishedAt,
            tags: snippet.tags ?? [],
            viewCount: Int(statics.viewCount) ?? 0,
            commentCount: Int(statics.commentCount) ?? 0,
            likeCount: Int(statics.likeCount) ?? 0,
            channelId: snippet.channelId,
            channelName: snippet.channelTitle,
            thumbnailURL: snippet.thumbnails.default.url,
            duration: item.contentDetails.duration
        )
    }

}
