//
//  UINavigationBarAdditions.swift
//  MovieListRXSwift
//
//  Created by Guillaume Bourachot on 16/12/2021.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    enum DisplayMode {
        case mainColor
    }

    func setUpNavigationBarColors(displayMode: DisplayMode) {
            switch displayMode {
            case .mainColor:
                self.barStyle = .default
                self.barTintColor = UIColor.init(named: "seaGreen") ?? .red
                self.isTranslucent = true
                self.tintColor = .white
                self.prefersLargeTitles = false
                self.backgroundColor = UIColor.init(named: "seaGreen") ?? .red
                self.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
        }

    
}
