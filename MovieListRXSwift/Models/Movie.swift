//
//  Movie.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 15/12/2021.
//

import Foundation

struct Movie {
    typealias Identifier = String
    
    let identifier: Identifier
    let title: String
    let year: Int?
    let rated: String?
    let releaseDate: Date?
    let runTime: String?
    let genres: [String]
    let directors: [String]
    let writers: [String]
    let actors: [String]
    let plot: String?
    let posterURL: URL?
    let votes: Int?
    let rating: Double?
}
