//
//  ViewController.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 19/04/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit
import CoreData

class ShowRecipeViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRecipe: Recipe?
    
    var ingredients = [Ingredient]()
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeLink: UILabel!
    @IBOutlet weak var recipePasos: UILabel!
    @IBOutlet weak var ingredientTable: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        
    }

    
    func loadInfo(){
        recipeTitle.text! = selectedRecipe!.title ?? "Nombre"
        recipeLink.text! = selectedRecipe!.link ?? "Link"
        recipePasos.text! = selectedRecipe!.pasos ?? "Pasos"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowIngredients") {
            let destinationVC = segue.destination as! IngredientsViewController
            destinationVC.selectedRecipe = selectedRecipe
        }
    }
    
}

