//
//  RecetasTableViewController.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 19/04/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit
import CoreData


class RecipesTableViewController: UITableViewController, UISearchBarDelegate {


    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recipes = [Recipe]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.dataSource = self
        tableView.delegate = self
        loadRecipes()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipesTableViewCell

        cell.recipeListLabel.text = recipes[indexPath.row].title
        cell.recipeListImage.layer.cornerRadius = 8.0
        cell.recipeListImage.clipsToBounds = true
        
        if recipes[indexPath.row].img != nil{
           let image = UIImage(data: recipes[indexPath.row].img!)
            cell.recipeListImage.image = image
        } else {
            cell.recipeListImage.image = UIImage(named: "salad")
        }

//        if let image = UIImage(data: recipes[indexPath.row].img!) {
//            cell.recipeListImage.image = image
//        } else {
//            cell.recipeListImage.image = UIImage(named: "salad")
//        }

        return cell
    }

    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowRecipe", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowRecipe") {
            let destinationVC = segue.destination as! ShowRecipeViewController
                
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedRecipe = recipes[indexPath.row]
            }
        } else if(segue.identifier == "AddRecipe") {
            let destinationVC = segue.destination as! AddRecipeViewController
            destinationVC.context = context
        }
    }
    
    // MARK: - Data manipulation methods
    
    func saveRecipe(recipe: Recipe) {
        do {
            try context.save()
        } catch {
            print("Error saving recipe \(error)")
        }
        tableView.reloadData()
    }
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipes = try context.fetch(request)
        } catch {
            print("Error loading recipes \(error)")
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Search Bar delegate methods
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          
        let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()

        let predicate = NSPredicate(format: "Recipe.title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
          
        do {
              recipes = try context.fetch(request)
        } catch {
              print("Error loading recipes \(error)")
        }
        tableView.reloadData()
      }

      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          if searchBar.text?.count == 0 {
              loadRecipes()

              DispatchQueue.main.async{
                  searchBar.resignFirstResponder()
              }
          }
      }
    
//    MARK:- Add a recipe
    
    @IBAction func addRecipe(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddRecipe", sender: self)
        
    }

    
//    MARK:- Delete a recipe

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if recipes.indices.contains(indexPath.row) {
                let recipeForDeletion = recipes[indexPath.row]
                context.delete(recipeForDeletion)
                recipes.remove(at: indexPath.row)

                do {
                    try context.save()
                } catch {
                    print("Could not delete recipe \(error)")
                }
            }
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    
    
//    MARK: - Navigation
    
     @IBAction func unwindFromAddRecipe(_ sender: UIStoryboardSegue) {
        if sender.source is AddRecipeViewController {
            if let senderVC = sender.source as? AddRecipeViewController {
                recipes.append(senderVC.newRecipe!)
                saveRecipe(recipe: senderVC.newRecipe!)
            }
            tableView.reloadData()
        }
        if sender.source is ShowRecipeViewController {
            if let senderVC = sender.source as? ShowRecipeViewController {
                context.delete(senderVC.selectedRecipe!)
                do {
                    try context.save()
                } catch {
                    print("Could not delete recipe \(error)")
                }
                loadRecipes()
                tableView.reloadData()
            }
        }
    }
    
}
