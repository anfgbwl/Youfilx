//
//  TargetType.swift
//  Youfilx
//
//  Created by hong on 2023/09/06.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: [String: String]? { get }
    var body: Encodable? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        do {
            guard var urlComponent = URLComponents(string: baseURL + path) else {
                throw AFError.explicitlyCancelled
            }
            if let queries = parameters {
                let queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
                urlComponent.queryItems = queryItems
            }
            guard var url = urlComponent.url else {
                throw AFError.explicitlyCancelled
            }
            if let urlString = url.absoluteString.removingPercentEncoding {
                url = URL(string: urlString)!
            }
            let urlRequest = try URLRequest(url: url, method: httpMethod, headers: headers)
            return urlRequest
        } catch {
            throw error
        }
    }
}
