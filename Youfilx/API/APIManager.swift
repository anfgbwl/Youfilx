//
//  APIManager.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/05.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func fetchVideos(pageToken: String, completion: @escaping (Result<Any, AFError>) -> Void) {
        let url = API.baseUrl + "videos"
        let apiParam = [
            "part": "snippet",
            "chart": "mostPopular",
            "regionCode": "KR",
            "key": API.key,
            "pageToken": "\(pageToken)"
        ] as [String: Any]
        
        AF.request(url, method: .get, parameters: apiParam)
            .validate()
            .responseJSON { response in
                completion(response.result)
                debugPrint(response)
            }
    }
}
