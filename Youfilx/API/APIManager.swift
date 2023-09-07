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
    
    func searchFetchVideos(pageToken: String, completion: @escaping (Result<Any, AFError>) -> Void) {
        let url = API.baseUrl + "search"
        let apiParam = [
            "part": "snippet",
            "key": API.key,
            "q": SearchViewController.searchText,
            "pageToken": "\(pageToken)"
        ] as [String: Any]
        
        AF.request(url, method: .get, parameters: apiParam)
            .validate()
            .responseJSON { response in
                completion(response.result)
                debugPrint(response)
            }
    }
    
    func request(_ type: TargetType, completion: @escaping ((Result<Data, AFError>) -> Void)) {
        AF.request(type)
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                }
                if let data = response.data {
                    completion(.success(data))
                }
            }
        
    }
    
    func `request`(_ type: TargetType) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            request(type) { result in
                switch result {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}

//search?part=snippet&maxResults=100&q=고양이
