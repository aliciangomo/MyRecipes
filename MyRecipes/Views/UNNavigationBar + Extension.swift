//
//  UNNavigationBar + Extension.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 04/05/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func customNavigationBar() {
        // color for button images, indicators and etc.
        self.tintColor = UIColor(named: K.BrandColors.darkGreen)

        // color for background of navigation bar
        // but if you use larget titles, then in viewDidLoad must write
        // navigationController?.view.backgroundColor = // your color
        self.barTintColor = .white
        self.isTranslucent = false

        // for larget titles
        // self.prefersLargeTitles = true

        // color for large title label
        // self.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.someColor]

        // color for standard title label
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: K.BrandColors.orange)!]

        // remove bottom line/shadow
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
}
