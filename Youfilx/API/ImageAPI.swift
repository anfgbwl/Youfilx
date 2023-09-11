//
//  ImageAPI.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/08.
//

import Foundation
import Alamofire

enum ImageAPI: TargetType {
    
    case image(_ url: String)
    
    var baseURL: String {
        return ""
    }
    
    var path: String {
        switch self {
        case let .image(url):
            return url
        }
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .image:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .image:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .image:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .image:
            return nil
        }
    }
    
    
}
