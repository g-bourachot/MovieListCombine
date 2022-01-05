//
//  MovieListRXSwiftTests.swift
//  MovieListRXSwiftTests
//
//  Created by Guillaume Bourachot on 13/12/2021.
//

import XCTest
import PromiseKit
@testable import MovieListRXSwift

class MovieListRXSwiftTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDecodeMovie() {
        // Given
        let dataResponse = MockJSON.movieData
        // When
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: dataResponse)
            // Then
            XCTAssertFalse(movie.title.isEmpty)
            XCTAssertFalse(movie.identifier.isEmpty)
            XCTAssertFalse(movie.releaseDate ?? Date() < Date())
            XCTAssertGreaterThan(movie.actors.count, 1)
        } catch let decodeError {
            print(decodeError)
            XCTFail(decodeError.localizedDescription)
        }
    }
    
    func testDecodeMovieSearch() {
        // Given
        let dataResponse = MockJSON.moviesData
        // When
        do {
            let movieSearch = try JSONDecoder().decode(MovieSearch.self, from: dataResponse)
            // Then
            XCTAssertFalse(movieSearch.movies.isEmpty)
        } catch let decodeError {
            print(decodeError)
            XCTFail(decodeError.localizedDescription)
        }
    }
    
    func testDecodeMovieSearchError() {
        // Given
        let dataResponse = MockJSON.movieSearchErrorData
        // When
        do {
            let movieSearchError = try JSONDecoder().decode(MovieSearch.self, from: dataResponse)
            // Then
            XCTAssertFalse(movieSearchError.error.isEmpty)
        } catch let decodeError {
            print(decodeError)
            XCTFail(decodeError.localizedDescription)
        }
    }
    
    
    func testMovieSearch() {
        // Given
        let searchText = "Dark knight"
        // When
        let expectation = self.expectation(description: "testMovieSearch")
        firstly {
            MovieAPI.shared.searchMovie(searchText: searchText).promise
        }.done { movieSearch in
            // Then
            if let error = movieSearch.error {
                XCTFail(error)
            } else {
                XCTAssertFalse(movieSearch.movies.isEmpty)
            }
        }.catch { error in
            XCTFail("Fail JSON Parsing indice :\(error)")
        }.finally {
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMovieSearchError() {
        // Given
        let searchText = "D"
        // When
        let expectation = self.expectation(description: "testMovieSearchError")
        firstly {
            MovieAPI.shared.searchMovie(searchText: searchText).promise
        }.done { movieSearch in
            // Then
            if let error = movieSearch.error {
                XCTAssertFalse(error.isEmpty)
                XCTAssertFalse(movieSearch.hasResponse)
            } else {
                XCTFail("Shouldn't happen")
            }
        }.catch { error in
            XCTFail("Fail JSON Parsing indice :\(error)")
        }.finally {
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMovieSearchByTitle() {
        // Given
        let searchTitle = "The Dark Knight"
        // When
        let expectation = self.expectation(description: "testMovieSearchByTitle")
        firstly {
            MovieAPI.shared.searchMovieByTitle(searchTitle).promise
        }.done { movie in
            // Then
            XCTAssertFalse(movie.title.isEmpty)
            XCTAssertFalse(movie.identifier.isEmpty)
            XCTAssertFalse(movie.releaseDate ?? Date() < Date())
            XCTAssertGreaterThan(movie.actors.count, 1)
        }.catch { error in
            XCTFail("Fail JSON Parsing indice :\(error)")
        }.finally {
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMovieSearchById() {
        // Given
        let searchId = "tt0468569"
        // When
        let expectation = self.expectation(description: "testMovieSearchById")
        firstly {
            MovieAPI.shared.searchMovieById(searchId).promise
        }.done { movie in
            // Then
            XCTAssertFalse(movie.title.isEmpty)
            XCTAssertFalse(movie.identifier.isEmpty)
            XCTAssertFalse(movie.releaseDate ?? Date() < Date())
            XCTAssertGreaterThan(movie.actors.count, 1)
        }.catch { error in
            XCTFail("Fail JSON Parsing indice :\(error)")
        }.finally {
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
