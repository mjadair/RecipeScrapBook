//
//  SingleRecipeViewController.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 21/08/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

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
            loadInstructions()
        }
    }
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SingleRecipeViewController.imageTapped(gesture:)))
        // add it to the image view;
        recipeImage.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(SingleRecipeViewController.ingredientsTapped(gesture:)))
        
        addIngredientButton.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(SingleRecipeViewController.instructionsTapped(gesture:)))
        
        addStepButton.addGestureRecognizer(tapGesture3)
        
        if (recipe!.image != nil) {
            recipeImage.image = fixOrientation(img: UIImage(data: recipe!.image!)!)
        }
            
        self.title = recipe?.name ?? "Recipe"
        
        recipeIngredients.delegate = self
        recipeIngredients.dataSource = self
        recipeInstructions.delegate = self
        recipeInstructions.dataSource = self

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! SwipeTableViewCell
            let ingredient = ingredients[indexPath.row]
            cell.textLabel?.text = "- " + ingredient.ingredient!
            cell.textLabel?.textAlignment = .right
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.numberOfLines = 0;
            if ((indexPath.item % 2 ) != 0) {
                cell.backgroundColor = UIColor.black
            }
            cell.accessoryType = ingredient.checked ? .checkmark : .none
            cell.delegate = self
            return cell
        }
        
        else if tableView == recipeInstructions {
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath) as! SwipeTableViewCell
            let instruction = instructions[indexPath.row]
            cell.textLabel?.text = "- " + instruction.instruction!
            cell.textLabel?.textAlignment = .right
            cell.textLabel?.textColor = UIColor.white
            cell.delegate = self
            cell.textLabel?.numberOfLines = 0;
            if ((indexPath.item % 2 ) != 0) {
                cell.backgroundColor = UIColor.black
            }
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
          if (gesture.view as? UIImageView) != nil {
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
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        saveRecipe()
      }
    
    @objc func instructionsTapped(gesture: UIGestureRecognizer) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new step", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add instruction", style: .default) { (action) in
            let newInstruction = Recipe_Instructions(context: self.context)
            newInstruction.instruction = textField.text!
            newInstruction.checked = false
            newInstruction.parentRecipe = self.recipe
            self.instructions.append(newInstruction)
            self.saveRecipe()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new instruction"
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
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                navigationController?.present(picker, animated: true, completion: nil)
            }
            
        }
        
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
        }
        
        
        func loadInstructions(with request: NSFetchRequest<Recipe_Instructions> = Recipe_Instructions.fetchRequest(), predicate: NSPredicate? = nil) {
            
            let recipePredicate = NSPredicate(format: "parentRecipe.name MATCHES %@", recipe!.name!)
            
            
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [recipePredicate, additionalPredicate])
            } else {
                request.predicate = recipePredicate
            }
            
            do {
                instructions = try context.fetch(request)
            } catch {
                print("Error fetching from db \(error)")
            }
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
    

//MARK: Extends the Single Recipe View Controller to have the Swipe Table View Cell Delegate MEthods
extension SingleRecipeViewController: SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] action, indexPath in

            if tableView == self.recipeIngredients {
                context.delete(ingredients[indexPath.row])
                ingredients.remove(at: indexPath.row)
            }
            
            else if tableView == self.recipeInstructions {
                context.delete(instructions[indexPath.row])
                instructions.remove(at: indexPath.row)
            }
            
            saveRecipe()
            
        }
        

        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 15, height: 15)).image { _ in
            UIImage(named: "delete_icon")?.draw(in: CGRect(x: 0, y: 0, width: 15, height: 15))
        }

        return [deleteAction]
    }
    
    
    
}
    

