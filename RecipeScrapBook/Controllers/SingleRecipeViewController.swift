//
//  SingleRecipeViewController.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 21/08/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit
import CoreData

class SingleRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    
    @IBAction func newImage() {
        
    }
    
    var recipe: Recipe = Recipe()
      
     var selectedRecipe: Recipe? {
         didSet {
           recipe = selectedRecipe!
         }
     }
      
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SingleRecipeViewController.imageTapped(gesture:)))
        // add it to the image view;
        recipeImage.addGestureRecognizer(tapGesture)
      
        
        self.title = recipe.name ?? "Recipe"

        // Do any additional setup after loading the view.
    }
    
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
          // if the tapped view is a UIImageView then set it to imageview
          if (gesture.view as? UIImageView) != nil {
              print("Image Tapped")
              //Here you can initiate your new ViewController
          }
      }
    
    




}
