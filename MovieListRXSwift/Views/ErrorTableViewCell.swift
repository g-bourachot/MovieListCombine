//
//  ErrorTableViewCell.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 16/12/2021.
//

import Foundation
import UIKit

class ErrorTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // MARK: - Public functions
    func configureCell(with errorMessage: String) {
        self.selectionStyle = .none
        self.errorMessageLabel.text = errorMessage
    }
}
