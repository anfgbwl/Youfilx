//
//  Data+.swift
//  Youfilx
//
//  Created by hong on 2023/09/06.
//

import Foundation

extension Data {
    func toObject<T: Decodable>(_ type: T.Type) throws -> T {
        do {
            let object = try JSONDecoder().decode(type, from: self)
            return object
        } catch {
            throw error
        }
    }
}
