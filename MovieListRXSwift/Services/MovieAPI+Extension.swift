//
//  MovieAPI+Extension.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 13/12/2021.
//

import Foundation

extension MovieAPIRequestBuilder {

    static let production = MovieAPIRequestBuilder(
        baseURLString: "http://www.omdbapi.com/"
    )
    static let preproduction = MovieAPIRequestBuilder(
        baseURLString: "http://www.omdbapi.com/"
    )
    
    static let apiKey: String = "8f8fb7fc"
}
