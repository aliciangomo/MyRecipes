//
//  DataBaseHelper.swift
//  MyRecipes
//
//  Created by Alicia Ngomo Fernandez on 08/05/2020.
//  Copyright © 2020 Alicia Ngomo Fernandez. All rights reserved.
//

import UIKit
import CoreData

class DataBaseHelper {
    
    static let shareInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data) {
        let recipe = Recipe(context: context)
        recipe.img = data
            
        do {
            try context.save()
            print("Image is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchRecipe() -> [Recipe] {
        var fetchingRecipe = [Recipe]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        
        do {
            fetchingRecipe = try context.fetch(fetchRequest) as! [Recipe]
        } catch {
            print("Error while fetching the image")
        }
        
        return fetchingRecipe
    }
}
