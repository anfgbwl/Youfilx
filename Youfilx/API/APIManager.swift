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
}
