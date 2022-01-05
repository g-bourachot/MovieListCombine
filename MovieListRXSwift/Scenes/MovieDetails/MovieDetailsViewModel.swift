//
//  MovieDetailsViewModel.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 16/12/2021.
//

import Foundation
import PromiseKit
import Combine

protocol MovieDetailsViewModelLogic: AnyObject {
    var movieAPI: MovieAPILogic { get }
    var itemPublisher: Published<Movie?>.Publisher { get }
    func searchMovieById(_ identifier: Movie.Identifier)
}

class MovieDetailsViewModel: MovieDetailsViewModelLogic {
    
    // MARK: - Variables
    var movieAPI: MovieAPILogic
    @Published var item: Movie?
    var itemPublisher: Published<Movie?>.Publisher { $item }
    
    init(movieAPI: MovieAPILogic) {
        self.movieAPI = movieAPI
    }
    
    func searchMovieById(_ identifier: Movie.Identifier) {
        firstly {
            self.movieAPI.searchMovieById(identifier).promise
        }.done { movie in
            self.item = movie
        }.catch { error in
            print(error)
            //self.item.onError(error)
        }
    }
}
