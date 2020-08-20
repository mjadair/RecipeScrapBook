//
//  CollectionViewCell.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 22/07/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var recipeLabel: UILabel!
    
    
    
    func toggleSelected ()
    {
        if (isSelected){
            print("cell is saying it is selected!")
        }else {
            print("cell is saying it is NOT selected!")
        }
    }
    
    
    

    
}
