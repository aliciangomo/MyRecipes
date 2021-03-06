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
    
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeLink: UILabel!
    @IBOutlet weak var recipePasos: UITextView!
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
        ingredientTable.allowsSelection = false
        loadInfo()
        loadIngredients()
        loadImage()
        ingredientTable.tableFooterView = UIView()
        ingredientTable.reloadData()
//        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
//        self.scrollView.setContentOffset(bottomOffset, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(recipesList))
    }
    
   
        
    @objc func recipesList () {
        let DestVC = storyboard!.instantiateViewController(withIdentifier: "MyRecipes") as! RecipesTableViewController
        self.navigationController!.pushViewController(DestVC, animated: true)
    }
    

    
    func loadInfo(){
        recipeTitle.text! = selectedRecipe!.title ?? "Recipe title"
        recipeLink.text! = selectedRecipe!.link ?? "Recipe link"
        recipePasos.text! = selectedRecipe!.pasos ?? "Recipe steps"
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
    
    func loadImage() {
         if selectedRecipe!.img != nil{
            let image = UIImage(data: selectedRecipe!.img!)
            recipeImageView.image = image
         } else {
            recipeImageView.image = UIImage(named: "salad")
         }
     }
    
    
//    MARK: - Table Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        cell.showLabel.text = ingredients[indexPath.row].name
        
        return cell
    }
    
//    MARK: - Delete recipe
    
    @IBAction func deleteRecipe(_ sender: UIBarButtonItem) {
      
    }
    
    
//    MARK: - Send recipe
    
    
    @IBAction func shareRecipe(_ sender: UIBarButtonItem) {
    
        let first = "Recipe: \(selectedRecipe?.title ?? "Test")"
        let second = "Link to recipe: \(selectedRecipe?.link ?? "Test")"
        let third = "Instructions: \(selectedRecipe?.pasos ?? "Test")"
        var fourth = "Ingredients: "
        
        for i in ingredients {
            fourth.append("\(i.name!), ")
        }
        print(ingredients)
        print("This is the value of \(fourth)")
//    // If you want to put an image
//    let image : UIImage = UIImage(named: "image.jpg")!

    let activityViewController : UIActivityViewController = UIActivityViewController(
        activityItems: [first, second, third, fourth], applicationActivities: nil)

//    // This lines is for the popover you need to show in iPad
//    activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)


        self.present(activityViewController, animated: true, completion: nil)
    
    }
    
    
    
//    MARK: - Navigation to edit recipe
    
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

}

