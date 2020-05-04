//
//  RecipesTableViewCell.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 04/05/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {

 
    @IBOutlet weak var recipeListImage: UIImageView!
    @IBOutlet weak var recipeListLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
