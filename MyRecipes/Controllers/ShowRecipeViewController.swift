//
//  ViewController.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 19/04/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit
import CoreData

class ShowRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRecipe: Recipe?
    
    var ingredients = [Ingredient]()
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeLink: UILabel!
    @IBOutlet weak var recipePasos: UITextView!
    @IBOutlet weak var ingredientTable: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTable.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
        loadInfo()
        loadIngredients()
        
        ingredientTable.tableFooterView = UIView()
        
        ingredientTable.reloadData()
    }

    
    func loadInfo(){
        recipeTitle.text! = selectedRecipe!.title ?? "Nombre"
        recipeLink.text! = selectedRecipe!.link ?? "Link"
        recipePasos.text! = selectedRecipe!.pasos ?? "Pasos"
    }
    
    
    func loadIngredients(){
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let predicate = NSPredicate(format: "parentRecipe.title CONTAINS[cd] %@", selectedRecipe!.title!)
        request.predicate = predicate
        do {
        ingredients = try context.fetch(request)
        } catch {
        print("Error loading ingredients \(error)")
        }
        ingredientTable.reloadData()
        print(ingredients)
    }

    
//    MARK: - Table Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredients[indexPath.row].name
        return cell
    }
    
//    MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "EditRecipe") {
        let destinationVC = segue.destination as! EditViewController
            
            destinationVC.loadViewIfNeeded()
            destinationVC.editedRecipe = selectedRecipe

            destinationVC.titleField?.text! = recipeTitle.text!
            destinationVC.linkField?.text! = recipeLink.text!
            destinationVC.pasosView?.text! = recipePasos.text!
            destinationVC.ingredients = ingredients
            
            }
            
    }
    
    @IBAction func unwindFromEditRecipe(_ sender: UIStoryboardSegue) {
           if sender.source is EditViewController {
               if let senderVC = sender.source as? EditViewController {
                selectedRecipe = senderVC.editedRecipe
               }
            
           }
       }
    
}

