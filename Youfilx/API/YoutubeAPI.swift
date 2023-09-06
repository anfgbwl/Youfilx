//
//  YoutubeAPI.swift
//  Youfilx
//
//  Created by hong on 2023/09/06.
//

import Foundation
import Alamofire

enum YoutubeAPI: TargetType {

    case videoInformation(_ videoId: String)
    case commentThread(_ videoId: String, _ nextPageToken: String? = nil)
    case commentsList(_ commentId: String, _ nextPageToken: String? = nil)
    
    var baseURL: String {
        return API.baseUrl
    }
    
    var path: String {
        switch self {
        case .videoInformation:
            return "videos"
        case .commentThread:
            return "commentThreads"
        case .commentsList:
            return "comments"
        }
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .videoInformation, .commentThread, .commentsList:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .videoInformation, .commentThread, .commentsList:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case let .videoInformation(videoId):
            return [
                "id": videoId,
                "key": API.key,
                "part": "snippet%2Cstatistics%2CContentDetails"
            ]
        case let .commentThread(videoId, nextPageToken):
            return [
                "videoId": videoId,
                "key": API.key,
                "part": "snippet",
                "order": "relevance",
                "maxResults": "10",
                "pageToken": nextPageToken ?? ""
            ]
        case let .commentsList(commentId, nextPageToken):
            return [
                "parentId": commentId,
                "key": API.key,
                "part": "snippet",
                "maxResults": "10",
                "pageToken": nextPageToken ?? ""
            ]
        }
    }
    
    var body: Encodable? {
        switch self {
        case .videoInformation, .commentThread, .commentsList:
            return nil
        }
    }
    
}