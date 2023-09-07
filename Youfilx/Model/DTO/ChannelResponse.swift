//
//  ChannelResponse.swift
//  Youfilx
//
//  Created by hong on 2023/09/06.
//

import Foundation

struct ChannelResponse: Decodable {
    
    let kind: String
    let etag: String
    let pageInfo: PageInfo
    let items: [ChannelItem]
    
    struct PageInfo: Decodable {
        let totalResults: Int
        let resultsPerPage: Int
    }
    
    struct ChannelItem: Decodable {
        let kind: String
        let etag: String
        let id: String
        let snippet: Snippet
        let statistics: Statistics
        
        struct Snippet: Decodable {
            let title: String
            let description: String
            let customUrl: String
            let publishedAt: String
            let thumbnails: Thumbnails
            
            struct Thumbnails: Decodable {
                let `default`: Thumbnail
                let medium: Thumbnail
                let high: Thumbnail
            }
            
            struct Thumbnail: Decodable {
                let url: String
                let width: Int
                let height: Int
            }
            
        }
        
        struct Statistics: Decodable {
            let viewCount: String
            let subscriberCount: String
            let hiddenSubscriberCount: Bool
            let videoCount: String
        }
    }
    
    func toChannelInformation() -> ChannelInformation {
        let item = items[0]
        let snippet = item.snippet
        let thumbnails = snippet.thumbnails
        return ChannelInformation(
            channelId: item.id,
            title: snippet.title,
            publishedAt: snippet.publishedAt,
            thumbnailURL: thumbnails.default.url,
            viewCount: item.statistics.viewCount,
            subscriberCount: item.statistics.subscriberCount,
            videoCount: item.statistics.videoCount
        )
    }
}
