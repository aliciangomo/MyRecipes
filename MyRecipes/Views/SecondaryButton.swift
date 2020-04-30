//
//  SecondaryButton.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 19/04/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import Foundation
import UIKit

class SecondaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    func setupButton() {
        setShadow()
        layer.cornerRadius = 7
//        layer.borderWidth = 1.0
//        layer.borderColor = (UIColor(named: K.BrandColors.green) as! CGColor)
        setTitleColor(UIColor.white, for: .normal)
        setGradient(colorOne: UIColor(named: K.BrandColors.beige)!, colorTwo: UIColor(named: K.BrandColors.orange)!)
        frame.size = CGSize(width: 350, height: 60)
    }
    
   
    private func setShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    func setGradient(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer =  CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius = 7
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
