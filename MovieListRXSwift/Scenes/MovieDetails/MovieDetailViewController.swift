//
//  MovieDetailsViewController.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 16/12/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import GBUIKitAdditions

protocol MovieDetailsDisplayLogic: AnyObject {
    
}

class MovieDetailsViewController: UIViewController {

    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: "MovieDetailsView", bundle: nil)
    }
    
    // MARK: - IButlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var directorsLabel: UILabel!
    @IBOutlet weak var writersLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    // MARK: - Variables
    var movieIdentifier: Movie.Identifier?
    private let bag = DisposeBag()
    private let viewModel: MovieDetailsViewModelLogic = MovieDetailsViewModel(movieAPI: MovieAPI.shared)
    
    // MARK: - Overrided functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchMovie()
        guard let movieId = self.movieIdentifier else {
            return
        }
        self.viewModel.searchMovieById(movieId)
    }
    
    // MARK: - Private functions
    private func setUpSearchMovie() {
        self.viewModel
            .item
            .subscribe(onNext: { [unowned self] movie in
                self.configureView(with: movie)
        })
        .disposed(by: bag)
    }
    
    private func configureView(with movie: Movie) {
        self.title = movie.title
        self.posterImageView.image = nil
        if let posterURL = movie.posterURL {
            self.posterImageView.downloadedFrom(url: posterURL,
                                                contentMode: .scaleAspectFit)
        }
        self.titleLabel.text = movie.title
        self.plotLabel.text = (movie.plot ?? "") + "\n"
        
        var yearRuntime = ""
        if let year = movie.year {
            yearRuntime = String(year)
        }
        if let runTime = movie.runTime {
            yearRuntime.append(" ∙ \(runTime)")
        }
        self.yearLabel.text = yearRuntime
        
        self.genresLabel.text = movie.genres.joined(separator: ", ")
        
        if movie.directors.count > 1 {
            let directorsAttributedString = NSMutableAttributedString()
                .bold("Directors: ", size: 15, color: .systemGray)
                .normal(movie.directors.joined(separator: ", "), size: 15, color: .systemGray)
            self.directorsLabel.attributedText = directorsAttributedString
        } else {
            let directorsAttributedString = NSMutableAttributedString()
                .bold("Director: ", size: 15, color: .systemGray)
                .normal(movie.directors.joined(separator: ", "), size: 15, color: .systemGray)
            self.directorsLabel.attributedText = directorsAttributedString
        }
        
        if movie.writers.count > 1 {
            let writersAttributedString = NSMutableAttributedString()
                .bold("Writers: ", size: 15, color: .systemGray)
                .normal(movie.writers.joined(separator: ", "), size: 15, color: .systemGray)
            self.writersLabel.attributedText = writersAttributedString
        } else {
            let writersAttributedString = NSMutableAttributedString()
                .bold("Writer: ", size: 15, color: .systemGray)
                .normal(movie.writers.joined(separator: ", "), size: 15, color: .systemGray)
            self.writersLabel.attributedText = writersAttributedString
        }
        
        if movie.actors.count > 1 {
            let actorsAttributedString = NSMutableAttributedString()
                .bold("Actors: ", size: 15, color: .systemGray)
                .normal(movie.actors.joined(separator: ", "), size: 15, color: .systemGray)
            self.actorsLabel.attributedText = actorsAttributedString
        } else {
            let actorsAttributedString = NSMutableAttributedString()
                .bold("Actor: ", size: 15, color: .systemGray)
                .normal(movie.actors.joined(separator: ", "), size: 15, color: .systemGray)
            self.actorsLabel.attributedText = actorsAttributedString
        }
        
        var votesRating = ""
        if let rating = movie.rating {
            votesRating += String(rating) + "/10"
        }
        
        if let votes = movie.votes {
            votesRating += " ∙ " + (Movie.numberFormatter.string(from: NSNumber(value: votes)) ?? "") + " votes"
        }
        
        self.votesLabel.text = votesRating
    }
}
