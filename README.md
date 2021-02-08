#  Recipe ScrapBook 
<img src= images/logo.png height=100 width=100 />

## Overview 

This is my final project as part of Harvard University's online CS50x, Introduction to Computer Science module. 

I decided to build an iOS app using Swift as I was unfamiliar with the technology and wanted to apply all the knowledge I had learned throughout the course to build something entirely new. 


## Technologies Used 💻

- Swift
- iOS
- Xcode

## The Approach 

### Models

The app uses the iOS devices inbuilt Core Data. I started by creating a model for data and the relationships required. 

<img src= images/datamodel.png height=200 width=400 />

Each recipe has a one to many relationship with ingredients and instructions. 

### Views

One of the most powerful features of building an iOS app with Xcode is the `Main.storyboard` file, where I was able to plot the layout and general appearance of the app using Xcode's GUI. Coming from a web development background where layouts are designed programatically, this was a new and interesting way of designing a layout.

<img src= images/storyboard.png height=200 width=400 />

The left-most iPhone screen in the example above shows that I have utilised a Navigation controller. This allows me to move between alternative views. 

The second screen shows a Collection View, which was used to show the collection of recipes all on one screen. When a user taps the individual recipe cell it will trigger a segue (initialised in the controller) that will take the user to the final view, the single recipe view.

The Single Recipe View has a number of inbuilt views. An Image and two table views. The latter two to display the ingredients and method associated with the recipe, respectively. 


### Controllers

The segue for from the collection view to the single recipe view is triggered as such:

```swift
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedRecipe = recipes[indexPath.row]
        
        if !isEditing {
            deleteButton.isEnabled = false
            performSegue(withIdentifier: "ShowSingleRecipe", sender: self)
        } else {
            deleteButton.isEnabled = true
        }
    }
```

The above function ensures the app is not in edit mode (for deleting or amending recipes) and then performs the segue to the single recipe view by running this function:

```swift

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
         if segue.identifier == "ShowSingleRecipe" {
             if let destVC = segue.destination as? SingleRecipeViewController {
                 destVC.recipe = selectedRecipe
             }
         }
        
    }
```

The controllers also deal with using the device's Core Data to fetch and update the recipe information - this was some of the most complex code to figure out for this project and it took a long time for me to understand how to accurately get the data to persist.

An interesting challenge that arose was, when saving the recipe image. The function below utilises the native `imagePickerController` function to select a photo from the user's picture library and save it to the database in binary:

```swift
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            navigationController?.dismiss(animated: true, completion: nil)
            if let image = info[UIImagePickerController.InfoKey.originalImage]
                as? UIImage {
                recipeImage.image = image
                recipe!.image = image.toData
                saveRecipe()
            }
        }
  ```
  
  The interesting challenge that arose from this was that when the image was reloaded, it would often be flipped upside down!
  
I was fortunately able to use the following logic to reverse the image if required:

```swift
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
```



## Challenges 




## Successes 



## Future features 

 





