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
    
    func fetchVideos(completion: @escaping (Result<Any, AFError>) -> Void) {
        let url = API.baseUrl + "videos"
        let apiParam = [
            "part":"snippet",
            "chart":"mostPopular",
            "maxResult":25,
            "regionCode":"KR",
            "key":API.key
        ] as [String : Any]
        
        AF.request(url, method: .get, parameters: apiParam)
            .validate()
            .responseJSON { response in
                completion(response.result)
                debugPrint(response)
            }
    }
}
