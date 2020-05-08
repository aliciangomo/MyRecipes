//
//  EditViewController.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 01/05/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var editedRecipe: Recipe?
    
    var ingredients = [Ingredient]()

    
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var pasosView: UITextView!
    @IBOutlet weak var ingredientsEditTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        linkField.delegate = self
        pasosView.delegate = self
        pasosView.isEditable = true
        pasosView.layer.borderWidth = 0.7
        pasosView.layer.borderColor = UIColor.lightGray.cgColor
        pasosView.layer.cornerRadius = 5
        ingredientsEditTable.rowHeight = 30.00
        ingredientsEditTable.dataSource = self
        ingredientsEditTable.delegate = self
        ingredientsEditTable.tableFooterView = UIView()
        editImageView.alpha = 0.25
    }
    
//    MARK: - TextField delegate methods
    
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return true
        }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.becomeFirstResponder()
            return true
        }


        func textFieldDidEndEditing(_ textField: UITextField) {
            editedRecipe!.title = titleField.text!
            editedRecipe!.link = linkField.text!
        }

        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        }
    
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
             if let title = titleField.text,
                let textRange = Range(range, in: title) {
                editedRecipe!.title = title.replacingCharacters(in: textRange,
                                                                  with: string)
            }
            
            if let link = linkField.text,
                let textRange = Range(range, in: link) {
                editedRecipe!.link = link.replacingCharacters(in: textRange,
                                                                  with: string)
            }
            return true
        }
    
//    MARK: - TextView delegate methods

        func textViewDidEndEditing(_ textField: UITextView) {
            editedRecipe!.pasos = pasosView.text!
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.textColor = UIColor.black
        }
    
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let pasos = pasosView.text,
                let textRange = Range(range, in: pasos) {
                editedRecipe!.pasos = pasos.replacingCharacters(in: textRange,
                                                                  with: text)
            }
            return true
        }
    
    
//    MARK: - TableView datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientEditedCell", for: indexPath) as! IngredientEditedTableViewCell
              cell.editLabel.text = ingredients[indexPath.row].name
              return cell
    }
    
//    MARK: - TableView delegate methods
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if ingredients.indices.contains(indexPath.row) {
                let ingredientForDeletion = ingredients[indexPath.row]
                context.delete(ingredientForDeletion)
                ingredients.remove(at: indexPath.row)

                do {
                    try context.save()
                } catch {
                    print("Could not delete ingredient \(error)")
                }
            }
            ingredientsEditTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    
//    MARK: - Add ingredient
    
    @IBAction func addIngredient(_ sender: UIButton) {

           var nameTextField = UITextField()

           let alert = UIAlertController(title: "Add new ingredient", message: "", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
        

               let newIngredient = Ingredient(context: self.context)
               newIngredient.name = nameTextField.text!
               self.ingredients.append(newIngredient)
               newIngredient.parentRecipe = self.editedRecipe
               self.saveIngredient(ingredient: newIngredient)

               self.ingredientsEditTable.reloadData()
           }))

           alert.addTextField { (name) in
               name.placeholder = "Type ingredient"
               nameTextField = name
           }

           present(alert, animated: true, completion: nil)
       }

    
//    MARK:- Change picture
    
    @IBAction func changePicture(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            
            let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a photo source", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {action in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(actionSheet, animated: true, completion: nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            editImageView.image = userPickedImage
            editImageView.alpha = 1
            picker.dismiss(animated: true)
            
            if let imageData = editImageView.image?.pngData() {
                saveImage(data: imageData)
            }
            
        }
        
        func saveImage(data: Data) {
            editedRecipe?.img = data
                
            do {
                try context.save()
                print("Image is saved")
            } catch {
                print(error.localizedDescription)
            }
        }
    
    
//     MARK: - Data manipulation methods

    func saveIngredient(ingredient: Ingredient) {
        do {
            try context.save()
        } catch {
            print("Error saving receta \(error)")
        }
        ingredientsEditTable.reloadData()
    }

    func loadIngredients(with request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest(), predicate: NSPredicate? = nil){
        do {
        ingredients = try context.fetch(request)
        } catch {
        print("Error loading ingredients \(error)")
        }
        ingredientsEditTable.reloadData()
    }
    
//     MARK: - Update recipe
    
    @IBAction func updateRecipe(_ sender: Any) {
        saveEditedRecipe(recipe: editedRecipe!)
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowController") as? ShowRecipeViewController else { return }
        
        vc.selectedRecipe = editedRecipe
        vc.ingredients = ingredients

        if let navCtrl = self.navigationController
        {
           navCtrl.pushViewController(vc, animated: true)
        }
        else
        {
           let navCtrl = UINavigationController(rootViewController: vc)
            self.present(navCtrl, animated: true, completion: nil)
        }
    }
    
    
    func saveEditedRecipe(recipe: Recipe) {
        do {
            try context.save()
        } catch {
            print("Error saving receta \(error)")
        }
        updateRecipesList()
    }

//    MARK: - Navigation
    
    func updateRecipesList() {
        let vc = RecipesTableViewController()
        vc.loadRecipes()
    }
    
    
}
