//
//  IngredientTableViewCell.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 04/05/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
