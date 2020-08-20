//
//  CollectionViewController.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 22/07/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "cell"

class RecipeCollectionViewController: UICollectionViewController {
    
    var recipes = [Recipe]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true;
        collectionView.allowsSelection = true
        
        loadRecipes()
    }
    
    
    
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
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipes.count
    }

    override func collectionView(_ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
           collectionView.dequeueReusableCell(withReuseIdentifier:
                reuseIdentifier, for: indexPath) as! RecipeCollectionViewCell

        cell.recipeLabel.text = recipes[indexPath.item].name
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8

        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        print("HELLO!")
        return true
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! RecipeCollectionViewCell
        
        
        print(cell)
        if cell.isSelected {
            cell.toggleSelected()
            print("Who?")
            collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
            return false
        }
        cell.toggleSelected()
        print("selected!")
        return true
    }
    
    
 

    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          print("\ndidSelectItemAt: \(indexPath.row)")
        print("You selected cell #\(indexPath.item)!")
        print("HELLO!")

        let cell = collectionView.cellForItem(at: indexPath) as! RecipeCollectionViewCell
        cell.toggleSelected()
         print(cell)
        
    
        
}


    
    //MARK: This it the function that loads our recipes
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        do {
             recipes = try context.fetch(request)
        } catch {
            print("Errors loading \(error)")
        }
        
        collectionView.reloadData()
    }
    
    
    func saveRecipes() {
        
        do {
            try context.save()
        } catch {
            print("Errors \(error)")
        }
        
        collectionView.reloadData()
        
    }

    
    
    

}
        



    


    






    
  

    
    
    


