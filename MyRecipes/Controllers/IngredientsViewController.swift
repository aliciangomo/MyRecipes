//
//  IngredientsViewController.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 19/04/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit
import CoreData

class IngredientsViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRecipe: Recipe?
    
    var ingredients = [Ingredient]()
    
    @IBOutlet weak var ingredientsTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    
//    MARK:- Data manipulation methods
    
    func loadIngredients() {
        
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        let predicate = NSPredicate(format: "attributeName == %@", selectedRecipe!.title!)
        request.predicate = predicate
        
            do {
            ingredients = try context.fetch(request)
            } catch {
            print(error)
            }
            ingredientsTable.reloadData()
        
    }
    
    //MARK:- Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)

        cell.textLabel?.text = ingredients[indexPath.row].name

        return cell
    }
    
    //MARK:- Table view delegate methods
    

}
