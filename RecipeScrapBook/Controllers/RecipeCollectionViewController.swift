//
//  CollectionViewController.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 21/08/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit
import CoreData

private let recipeCell = "Recipe Cell"

class RecipeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var recipes = [Recipe]()
    var selectedRecipe = Recipe()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
  
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipes()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    //MARK: + BUTTON PRESSED
    @IBAction func addButtonPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new recipe", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newRecipe = Recipe(context: self.context)
            newRecipe.name = textField.text!
            self.recipes.append(newRecipe)
            self.saveRecipes()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: SECTION COUNT
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: CELL COUNT
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    
    //MARK: CUSTOMISES CELL APPEARANCE
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier:
                recipeCell, for: indexPath) as! RecipeCollectionViewCell
        
//        cell.recipeLabel.text = recipes[indexPath.item].name
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.isInEditingMode = isEditing

        
        if (recipes[indexPath.item].image != nil) {
            cell.backgroundView = UIImageView(image: UIImage(data: recipes[indexPath.item].image!))
        }
        
        return cell
    }
    
     //MARK: USER SELECTION
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedRecipe = recipes[indexPath.row]
        
        if !isEditing {
            deleteButton.isEnabled = false
            performSegue(withIdentifier: "ShowSingleRecipe", sender: self)
        } else {
            deleteButton.isEnabled = true
        }
        

        
      
    
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deleteButton.isEnabled = false
        }
    }

     
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
         if segue.identifier == "ShowSingleRecipe" {
             if let destVC = segue.destination as? SingleRecipeViewController {
                 destVC.recipe = selectedRecipe
             }
         }
        
    }
    
    
    //MARK: LOAD RECIPES
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        do {
            recipes = try context.fetch(request)
        } catch {
            print("Errors loading \(error)")
        }
        
        collectionView.reloadData()
    }
    
    
    //MARK: SAVE RECIPES
    func saveRecipes() {
        
        do {
            try context.save()
        } catch {
            print("Errors \(error)")
        }
        
        collectionView.reloadData()
        
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! RecipeCollectionViewCell
            cell.isInEditingMode = editing
        }
    }
    
    
    @IBAction func deleteItem(_ sender: Any) {
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            
            let sortedItems = selectedCells.sorted()
    
            for item in sortedItems.reversed() {
                print(item.row)
            context.delete(recipes[item.row])
            recipes.remove(at: item.row)

          }
          collectionView.deleteItems(at: selectedCells)
          self.saveRecipes()
          deleteButton.isEnabled = false
        }
    }
    
}

