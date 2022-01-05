//
//  MockJSON.swift
//  MovieListRXSwiftTests
//
//  Created by Guillaume Bourachot on 15/12/2021.
//

import Foundation
class MockJSON{
    
    static var movieData: Data {
        return MockJSON.loadDataFromJSON(with: "MovieSearchByTitle")
    }
    
    static var moviesData: Data {
        return MockJSON.loadDataFromJSON(with: "MovieSearch")
    }
    
    static var movieSearchErrorData: Data {
        return MockJSON.loadDataFromJSON(with: "SearchError")
    }
    
    static func loadDataFromJSON(with name : String) -> Data {
        let path = Bundle(for: MockJSON.self).path(forResource: name, ofType: "json")!
        return try! Data(contentsOf: URL(fileURLWithPath : path))
    }
}
