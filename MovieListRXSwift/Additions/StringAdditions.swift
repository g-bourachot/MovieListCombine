//
//  StringAdditions.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 15/12/2021.
//

import Foundation

extension String {
    func apiValue() -> String? {
        if self == MovieAPI.nilAPIStringValue {
            return nil
        } else {
            return self
        }
    }
}

extension Optional where Wrapped == String {
    func apiValue() -> String? {
        switch self {
        case .none:
            return nil
        case .some(let stringValue):
            if stringValue == MovieAPI.nilAPIStringValue {
                return nil
            } else {
                return stringValue
            }
        }
    }
    
    var isEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let string):
            return string.isEmpty
        }
    }
}
