//
//  IngredientEditedTableViewCell.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 04/05/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit

class IngredientEditedTableViewCell: UITableViewCell {

    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editPicture: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
