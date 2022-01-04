//
//  MovieAPI+JSON.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 13/12/2021.
//

import Foundation

struct MovieSearch: Decodable {
    let movies: [Movie]
    let totalResults: Int?
    let hasResponse: Bool
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case hasResponse = "Response"
        case error = "Error"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let movies = try container.decodeIfPresent([Movie].self, forKey: .search) {
            self.movies = movies
        } else {
            self.movies = []
        }
        if let totalResultsString = try container.decodeIfPresent(String.self, forKey: .totalResults) {
            self.totalResults = Int(totalResultsString)
        } else {
            self.totalResults = nil
        }
        
        let hasResponseString = try container.decode(String.self, forKey: .hasResponse)
        if hasResponseString == "False" {
            self.hasResponse = false
        } else {
            self.hasResponse = true
        }
        
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
    }
    
    init(movies: [Movie],
         totalResults: Int?,
         hasResponse: Bool,
         error: String?) {
        self.movies = movies
        self.totalResults = totalResults
        self.hasResponse = hasResponse
        self.error = error
    }
}

extension Movie: Decodable {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }()
    
    static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()

    enum CodingKeys: String, CodingKey {
        case identifier = "imdbID"
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case releaseDate = "Released"
        case runTime = "Runtime"
        case genres = "Genre"
        case directors = "Director"
        case writers = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case posterURL = "Poster"
        case votes = "imdbVotes"
        case rating = "imdbRating"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(Movie.Identifier.self, forKey: .identifier)
        self.title = try container.decode(String.self, forKey: .title)
        if let yearString = try container.decode(String.self, forKey: .year).apiValue() {
            self.year = Int(yearString)
        }else {
            self.year = nil
        }
        
        self.rated = try container.decodeIfPresent(String.self, forKey: .rated).apiValue()
        
        if let releasedDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate).apiValue(),
           let releaseDate = Movie.dateFormatter.date(from: releasedDateString)
        {
            self.releaseDate = releaseDate
        } else {
            self.releaseDate = nil
        }
        
        self.runTime = try container.decodeIfPresent(String.self, forKey: .runTime).apiValue()
        if let genresString = try container.decodeIfPresent(String.self, forKey: .genres).apiValue() {
            self.genres = genresString.split(separator: ",").map { String($0) }
        } else {
            self.genres = []
        }
        if let directorsString = try container.decodeIfPresent(String.self, forKey: .directors).apiValue() {
            self.directors = directorsString.split(separator: ",").map { String($0) }
        } else {
            self.directors = []
        }
        if let writersString = try container.decodeIfPresent(String.self, forKey: .writers).apiValue() {
            self.writers = writersString.split(separator: ",").map { String($0) }
        } else {
            self.writers = []
        }
        if let actorsString = try container.decodeIfPresent(String.self, forKey: .actors).apiValue() {
            self.actors = actorsString.split(separator: ",").map { String($0) }
        } else {
            self.actors = []
        }
        self.plot = try container.decodeIfPresent(String.self, forKey: .plot).apiValue()
        
        if let posterURLString = try container.decodeIfPresent(String.self, forKey: .posterURL).apiValue(),
           let posterURL = URL.init(string: posterURLString) {
            self.posterURL = posterURL
        } else {
            self.posterURL = nil
        }
        
        if let votesString = try container.decodeIfPresent(String.self, forKey: .votes).apiValue(),
           let votes = Movie.numberFormatter.number(from: votesString)?.intValue {
            self.votes = votes
        } else {
            self.votes = nil
        }
        
        if let ratingString = try container.decodeIfPresent(String.self, forKey: .rating).apiValue() {
            self.rating = Double(ratingString)
        } else {
            self.rating = nil
        }
    }
}
