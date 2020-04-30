//
//  AddRecipeViewController.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 19/04/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit
import CoreData

class AddRecipeViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var newRecipe: Recipe?

    var ingredients = [Ingredient]()


    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var pasosView: UITextView!
    @IBOutlet weak var ingredientTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        linkField.delegate = self
        pasosView.delegate = self
        pasosView.isEditable = true
        pasosView.layer.borderWidth = 0.7
        pasosView.layer.borderColor = UIColor.lightGray.cgColor
        pasosView.layer.cornerRadius = 5
        ingredientTable.rowHeight = 30.00
        ingredientTable.dataSource = self
        ingredientTable.delegate = self

        newRecipe = Recipe(context: self.context)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
//    MARK: - TextField delegate methods

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.becomeFirstResponder()
            return true
        }


        func textFieldDidEndEditing(_ textField: UITextField) {
            newRecipe!.title = titleField.text!
            newRecipe!.link = linkField.text!
        }

        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        }

//    MARK: - TextView delegate methods


        func textViewDidEndEditing(_ textField: UITextView) {
            newRecipe!.pasos = pasosView.text!
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    

//    MARK: - Tableview data source methods (Ingredients table)

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientAddedCell", for: indexPath)

        cell.textLabel?.text = ingredients[indexPath.row].name
        return cell
    }


//    MARK: - Tableview delegate methods (Ingredients table)

    @IBAction func addIngredient(_ sender: UIButton) {

        var nameTextField = UITextField()

        let alert = UIAlertController(title: "Add new ingredient", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add ingredient", style: .default) {(action) in

            let newIngredient = Ingredient(context: self.context)
            newIngredient.name = nameTextField.text!
            self.ingredients.append(newIngredient)
            newIngredient.parentRecipe = self.newRecipe
            self.saveIngredient(ingredient: newIngredient)

            self.ingredientTable.reloadData()
        }

        alert.addTextField { (name) in
            name.placeholder = "Type ingredient"
            nameTextField = name
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


//     MARK: - Data manipulation methods

    func saveIngredient(ingredient: Ingredient) {
        do {
            try context.save()
        } catch {
            print("Error saving receta \(error)")
        }
        ingredientTable.reloadData()
    }

    func loadIngredients(with request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest(), predicate: NSPredicate? = nil){
        do {
        ingredients = try context.fetch(request)
        } catch {
        print("Error loading ingredients \(error)")
        }
        ingredientTable.reloadData()
    }


//     MARK: - Save recipe

    @IBAction func finishRecipe(_ sender: UIBarButtonItem) {
        saveRecipe(recipe: newRecipe!)
    }


    func saveRecipe(recipe: Recipe) {
        do {
            try context.save()
        } catch {
            print("Error saving receta \(error)")
        }
    }

//    MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if newRecipe != nil {
        }
    }
    
}
