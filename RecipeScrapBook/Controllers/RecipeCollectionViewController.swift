//
//  CollectionViewController.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 22/07/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class RecipeCollectionViewController: UICollectionViewController {
    
    var recipes: [Recipe] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
    }
    
    
    
    @IBAction func createNote() {
        let _ = RecipeManager.shared.create()
        reload()
    }
    
    
    // Reloads the view, by getting all the notes from the database and reloading the view
    func reload() {
        recipes = RecipeManager.shared.getRecipes()
        collectionView.reloadData()
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

        cell.recipeLabel.text = "Recipe!"
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8

        return cell
    }
    
    
    
       override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // handle tap events
            print("You selected cell #\(indexPath.item)!")
        
        print("HELLO!")
        
//        RecipeManager.shared.deleteRecipe(id: Int32(indexPath.item))
        reload()
        
}



}
        



    // Uncomment this method to specify if the specified item should be selected
func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 
    


    






    
  

    
    
    


