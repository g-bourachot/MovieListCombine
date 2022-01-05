//
//  MovieListTableViewCell.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 15/12/2021.
//

import Foundation
import UIKit
import GBExtensions

class MovieListTableViewCell: UITableViewCell {
 
    // MARK: - IBOutlets
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Public functions
    func configureCell(with movie: Movie) {
        self.selectionStyle = .none
        self.posterImageView.image = nil
        self.movieTitleLabel.text = movie.title
        if let posterURL = movie.posterURL {
            self.posterImageView.downloadedFrom(url: posterURL,
                                                contentMode: .scaleAspectFit)
        }
        if let year = movie.year {
            self.descriptionLabel.text = String(year)
        } else {
            self.descriptionLabel.text = nil
        }
    }
}
