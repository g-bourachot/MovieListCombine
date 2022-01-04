//
//  MovieListModels.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 16/12/2021.
//

import Foundation

enum MovieList {
    enum CellModel: Hashable {
        case movie(Movie)
        case error(String)
        case empty
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .movie(let movie):
                hasher.combine(movie.identifier)
            case .error(let stringError):
                hasher.combine(stringError)
            case .empty:
                hasher.combine("emptyMovieCell")
            }
          
        }

        static func == (lhs: CellModel, rhs: CellModel) -> Bool {
            switch (lhs, rhs) {
            case (.movie(let left), .movie(let right)):
                return left.identifier == right.identifier
            case (.error(let left), .error(let right)):
                return left == right
            default:
                return false
            }
        }
    }
}
