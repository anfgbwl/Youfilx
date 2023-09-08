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
