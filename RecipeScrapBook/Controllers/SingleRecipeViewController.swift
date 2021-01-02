//
//  SingleRecipeViewController.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 21/08/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit
import CoreData

class SingleRecipeViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeIngredients: UITableView!
    @IBOutlet weak var recipeInstructions: UITableView!
    
    @IBOutlet weak var addIngredientButton: UIButton!
    
    @IBOutlet weak var addStepButton: UIButton!
    
    @IBAction func newImage() {
        
    }
    
//    var recipe: Recipe = Recipe()
    var ingredients = [Recipe_Ingredients]()
    var instructions = [Recipe_Instructions]()
    
    var recipe: Recipe? {
        didSet {
           loadIngredients()
        }
    }
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SingleRecipeViewController.imageTapped(gesture:)))
        // add it to the image view;
        recipeImage.addGestureRecognizer(tapGesture)
        
        recipeInstructions.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(SingleRecipeViewController.ingredientsTapped(gesture:)))
        
        recipeIngredients.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(SingleRecipeViewController.ingredientsTapped(gesture:)))
        
        recipeIngredients.addGestureRecognizer(tapGesture3)
        
        if (recipe!.image != nil) {
            recipeImage.image = fixOrientation(img: UIImage(data: recipe!.image!)!)
        }
            
        self.title = recipe?.name ?? "Recipe"
        
        recipeIngredients.delegate = self
        recipeIngredients.dataSource = self
        recipeInstructions.delegate = self
        recipeInstructions.dataSource = self

        // Do any additional setup after loading the view.
//        self.loadIngredients()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recipeIngredients {
            return ingredients.count
        }
        
        else if tableView == recipeInstructions {
            return instructions.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == recipeIngredients {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
            let ingredient = ingredients[indexPath.row]
            cell.textLabel?.text = ingredient.ingredient
            cell.accessoryType = ingredient.checked ? .checkmark : .none
            return cell
        }
        
        else if tableView == recipeInstructions {
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
            cell.textLabel?.text = instructions[indexPath.row].instruction
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recipeIngredients {
        ingredients[indexPath.row].checked = !ingredients[indexPath.row].checked
        self.recipeIngredients.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        saveRecipe()
            
        }
    }
    

    
      


   
    
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
          // if the tapped view is a UIImageView then set it to imageview
          if (gesture.view as? UIImageView) != nil {
//              print("Image Tapped")
              //Here you can initiate your new ViewController
          }
      }
    
    
    @objc func ingredientsTapped(gesture: UIGestureRecognizer) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ingredient", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newIngredient = Recipe_Ingredients(context: self.context)
            newIngredient.ingredient = textField.text!
            newIngredient.checked = false
            newIngredient.parentRecipe = self.recipe
            self.ingredients.append(newIngredient)
            self.saveRecipe()
            print(self.ingredients)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        saveRecipe()
      }

    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
            
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
            
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            
       return normalizedImage
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
                recipe!.image = image.toData
                saveRecipe()
            }
        }
        
        
        
        func loadIngredients(with request: NSFetchRequest<Recipe_Ingredients> = Recipe_Ingredients.fetchRequest(), predicate: NSPredicate? = nil) {
            
            let recipePredicate = NSPredicate(format: "parentRecipe.name MATCHES %@", recipe!.name!)
            
            
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [recipePredicate, additionalPredicate])
            } else {
                request.predicate = recipePredicate
            }
            
            do {
                ingredients = try context.fetch(request)
            } catch {
                print("Error fetching from db \(error)")
            }
            
            
//            recipeIngredients.reloadData()
        }
        
        
        
        //MARK: SAVE RECIPES
         func saveRecipe() {
             
             do {
                 try context.save()
             } catch {
                 print("Errors \(error)")
             }
            recipeIngredients.reloadData()
            recipeInstructions.reloadData()
         }
        
        
        
        
    }


extension UIImage {
    var toData: Data? {
        return pngData()
    }
}
    
    
    

