//
//  SingleRecipeViewController.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 21/08/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit
import CoreData

class SingleRecipeViewController: UIViewController, UINavigationControllerDelegate {
    
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



    extension SingleRecipeViewController: UIImagePickerControllerDelegate {
        
        @IBAction func choosePhoto() {
            // if the user photo library is available
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                // use the controller
                let picker = UIImagePickerController()
                // assign values to keys
                picker.delegate = self
                picker.sourceType = .photoLibrary
                
                // assign the controller to present the image selected, with the additional keys added above
                navigationController?.present(picker, animated: true, completion: nil)
            }
            
        }
        
        
        
        // This function displays the image selected from the photo library in our main view.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            navigationController?.dismiss(animated: true, completion: nil)
            if let image = info[UIImagePickerController.InfoKey.originalImage]
                as? UIImage {
                recipeImage.image = image
                recipe.image = image.toData
                
                saveRecipe()
            }
        }
        
        
        
        //MARK: SAVE RECIPES
         func saveRecipe() {
             
             do {
                 try context.save()
             } catch {
                 print("Errors \(error)")
             }
             
         }
        
        
        
        
    }
    

extension UIImage {
    
    var toData: Data? {
        return pngData()
    }
    
    
}
    
    
    

