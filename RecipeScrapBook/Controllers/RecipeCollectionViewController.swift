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
        }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
//     Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }

     func collectionView(_ collectionView: UICollectionView, performAction action: UILongPressGestureRecognizer, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        print("What?")
    
    }
    
    


}




    
  

    
    
    
    
//    
//    // MARK: - UICollectionViewDelegate protocol
//    

//}


