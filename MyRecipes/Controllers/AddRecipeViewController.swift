//
//  AddRecipeViewController.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 19/04/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var newRecipe: Recipe?
    
    var ingredients = [Ingredient]()
    var recipes = [Recipe]()
    
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var pasosField: UITextField!
    @IBOutlet weak var ingredientTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        linkField.delegate = self
        pasosField.delegate = self
        newRecipe = Recipe()
        ingredientTable.rowHeight = 30.00
        
    }
    
//    MARK: - TextField delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.becomeFirstResponder()
            return true
        }


        func textFieldDidEndEditing(_ textField: UITextField) {
    
        }

        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != "" {
                textField.resignFirstResponder()
                return true
            } else{
                textField.placeholder = "Type something"
                return false
            }
        }
    
    
//    MARK: - Tableview data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)

        cell.textLabel?.text = ingredients[indexPath.row].name
        return cell
    }
    
    
//    MARK: - Tableview delegate methods
    
    @IBAction func addIngredient(_ sender: UIButton) {
        
        var nameTextField = UITextField()
              
              let alert = UIAlertController(title: "Add new ingredient", message: "", preferredStyle: .alert)
              
              let action = UIAlertAction(title: "Add ingredient", style: .default) {(action) in
                    
                
                  let newIngredient = Ingredient(context: self.context)
                  newIngredient.name = nameTextField.text!
                  self.ingredients.append(newIngredient)
                self.context.insert(self.newRecipe!)
                newIngredient.parentRecipe = self.newRecipe
                  self.saveIngredient(ingredient: newIngredient)
                
              }
          
              alert.addTextField { (name) in
              name.placeholder = "Type ingredient"
              nameTextField = name
              }
              
              
              alert.addAction(action)
              
              present(alert, animated: true, completion: nil)
          }
    
    
    
    //MARK: - Data manipulation methods
    
    func saveIngredient(ingredient: Ingredient) {
            do {
                try context.save()
            } catch {
                print("Error saving receta \(error)")
            }
            ingredientTable.reloadData()
    }

    
    func loadRecipes(with request: NSFetchRequest<Recipe> = Recipe.fetchRequest(), predicate: NSPredicate? = nil) {
            do {
                recipes = try context.fetch(request)
            } catch {
                print(error)
            }
    }
    
    //MARK: - Save recipe
    
    @IBAction func saveRecipe(_ sender: UIBarButtonItem) {
            newRecipe!.title = titleField.text!
            newRecipe!.link = linkField.text!
            newRecipe!.pasos = pasosField.text!
        saveRecipe(recipe: newRecipe!)
        }
    
    func saveRecipe(recipe: Recipe) {
        do {
            try context.save()
        } catch {
            print("Error saving receta \(error)")
        }
    }
    
}
