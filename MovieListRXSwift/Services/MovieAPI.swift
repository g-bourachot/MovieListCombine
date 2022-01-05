//
//  MovieAPI.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 13/12/2021.
//

import Foundation
import PromiseKit

protocol MovieAPILogic: AnyObject {
    var previousSearch: MovieSearch? { get }
    func searchMovie(searchText: String) -> (promise: Promise<MovieSearch>, cancel: () -> Void)
    func searchMovieByTitle(_ title: String) -> (promise: Promise<Movie>, cancel: () -> Void)
    func searchMovieById(_ identifier: String) -> (promise: Promise<Movie>, cancel: () -> Void)
}

class MovieAPI {
    
    static let nilAPIStringValue = "N/A"
    
    //MARK: - Struct and Enums
    enum Error: Swift.Error {
        case defaultError
        case cancelled
    }
    
    // MARK: - Singleton
    static let shared: MovieAPILogic = MovieAPI(requestBuilder: MovieAPIRequestBuilder.production)
    
    // MARK: - Variables
    let requestBuilder: MovieAPIRequestBuilder
    let urlSession: URLSession
    var previousSearch: MovieSearch?
    
    //MARK: - Initializers
    public init(requestBuilder: MovieAPIRequestBuilder) {
        self.requestBuilder = requestBuilder
        self.urlSession = URLSession.shared
    }
    
    //MARK: - Private functions
    private func cancellablePromise<T: Decodable>(_ request: URLRequest) -> (promise: Promise<T>, cancel: () -> Void) {
        var urlSessionDataTask: URLSessionDataTask?
        var cancelme = false
        
        let (promise, resolver) = Promise<T>.pending()
        //let promise = Promise<T> { seal in
            urlSessionDataTask = urlSession.dataTask(with: request) {(data, response, error) in
                guard !cancelme else {
                    resolver.reject(PMKError.cancelled)
                    return
                }
                if let data = data, let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        do {
                            resolver.fulfill(try JSONDecoder().decode(T.self, from: data))
                        } catch {
                            resolver.reject(error)
                        }
                    default:
                        resolver.reject(Error.defaultError)
                    }
                } else {
                    resolver.reject(Error.defaultError)
                }
            }
            urlSessionDataTask!.resume()
        //}
        let cancel = {
            cancelme = true
            urlSessionDataTask?.cancel()
            resolver.reject(MovieAPI.Error.cancelled)
        }
        return (promise: promise, cancel: cancel)
    }
}

extension MovieAPI: MovieAPILogic {
    func searchMovie(searchText: String) -> (promise: Promise<MovieSearch>, cancel: () -> Void) {
        var cancelMethod: () -> Void = { }
        let promise = Promise<MovieSearch> { seal in
            let searchRequest = self.requestBuilder.searchMovie(searchText)
            let searchPromise: (promise: Promise<MovieSearch>, cancel: () -> Void) = self.cancellablePromise(searchRequest)
            cancelMethod = searchPromise.cancel
            firstly {
                searchPromise.promise
            }.done { result in
                self.previousSearch = result
                seal.fulfill(result)
            }.catch { error in
                if case MovieAPI.Error.cancelled = error {
                    if let previousSearch = self.previousSearch {
                        seal.fulfill(previousSearch)
                    } else {
                        seal.fulfill(.init(movies: [],
                                           totalResults: 0,
                                           hasResponse: true,
                                           error: nil))
                    }
                } else {
                    seal.reject(error)
                }
            }
        }
        return (promise, cancelMethod)
    }
    
    func searchMovieByTitle(_ title: String) -> (promise: Promise<Movie>, cancel: () -> Void) {
        var cancelMethod: () -> Void = { }
        let promise = Promise<Movie> { seal in
            let searchRequest = self.requestBuilder.getMovieByTitle(title)
            let searchPromise: (promise: Promise<Movie>, cancel: () -> Void) = self.cancellablePromise(searchRequest)
            cancelMethod = searchPromise.cancel
            firstly {
                searchPromise.promise
            }.done { result in
                seal.fulfill(result)
            }.catch { error in
                seal.reject(error)
            }
        }
        return (promise, cancelMethod)
    }
    func searchMovieById(_ identifier: String) -> (promise: Promise<Movie>, cancel: () -> Void) {
        var cancelMethod: () -> Void = { }
        let promise = Promise<Movie> { seal in
            let searchRequest = self.requestBuilder.getMovieById(identifier)
            let searchPromise: (promise: Promise<Movie>, cancel: () -> Void) = self.cancellablePromise(searchRequest)
            cancelMethod = searchPromise.cancel
            firstly {
                searchPromise.promise
            }.done { result in
                seal.fulfill(result)
            }.catch { error in
                seal.reject(error)
            }
        }
        return (promise, cancelMethod)
    }
}
