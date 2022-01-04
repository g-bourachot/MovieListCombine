//
//  MovieDetailsViewModel.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 16/12/2021.
//

import Foundation
import RxSwift
import RxCocoa
import PromiseKit

protocol MovieDetailsViewModelLogic: AnyObject {
    var movieAPI: MovieAPILogic { get }
    var item: PublishSubject<Movie> { get }
    func searchMovieById(_ identifier: Movie.Identifier)
}

class MovieDetailsViewModel: MovieDetailsViewModelLogic {
    
    // MARK: - Variables
    var movieAPI: MovieAPILogic
    var item = PublishSubject<Movie>()
    
    init(movieAPI: MovieAPILogic) {
        self.movieAPI = movieAPI
    }
    
    func searchMovieById(_ identifier: Movie.Identifier) {
        firstly {
            self.movieAPI.searchMovieById(identifier).promise
        }.done { movie in
            self.item.onNext(movie)
        }.catch { error in
            self.item.onError(error)
        }
    }
}
