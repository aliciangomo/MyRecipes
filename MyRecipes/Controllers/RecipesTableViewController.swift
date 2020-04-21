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


    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recipes = [Recipe]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        tableView.rowHeight = 80.0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)

        cell.textLabel?.text = recipes[indexPath.row].title

        return cell
    }

    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowRecipe") {
            let destinationVC = segue.destination as! ShowRecipeViewController
                
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedRecipe = recipes[indexPath.row]
            }
        }
        
    }
    
    // MARK: - Data manipulation methods
    
    func saveRecipe(recipe: Recipe) {
        do {
            try context.save()
        } catch {
            print("Error saving receta \(error)")
        }
        tableView.reloadData()
    }
    
    func loadRecipes(with request: NSFetchRequest<Recipe> = Recipe.fetchRequest(), predicate: NSPredicate? = nil) {
            do {
                recipes = try context.fetch(request)
            } catch {
                print(error)
            }
            tableView.reloadData()
    }
    

    
    // MARK: - Search Bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          
          let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()

          let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
          request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

          loadRecipes(with: request, predicate: predicate)
          
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
    
    
}
