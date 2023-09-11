//
//  And.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/06.
//

import Foundation

public protocol And {}

extension And {
    @inlinable
    public func and(_ block: ((Self) throws -> Void)) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: And {}
