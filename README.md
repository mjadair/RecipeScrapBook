#  Recipe ScrapBook

## Overview 

This is my final project as part of Harvard University's online CS50x, Introduction to Computer Science module. 

I decided to build an iOS app using Swift as I was unfamiliar with the technology and wanted to apply all the knowledge I had learned throughout the course to build something entirely new. 


## Technologies Used 💻

- Swift
- iOS
- Xcode

## The Approach 

### The Phaser Boilerplate

The project started using a typical Phaser boilerplate. Creating a `GameScene` class that extends the `Phaser.Scene` object. 

The class typically utilises three functions: `preload()` for preparing images and sounds ready for the game to use. `create()` for adding game logic and `update()` which listens for changes to the game's state and executes functions accordingly:

```js

class GameScene extends Phaser.Scene {
  constructor() {
    super({ key: 'GameScene' })
  }
  
  preload() {
  ...
  }
  
  
  create() {
  ... 
  }
  
  
 update() {
   ...
   }
   
```

### The Config

Phaser requires a configuration object with certain stipulated keys in order for the game to render.

Here I have added physics to the game, a brilliantly useful tool that Phaser provides out of the box. I've also set the width and height of the canvas to match the `window.innerWidth` and `window.innerHeight` of the device being used so that the game experience is similar on mobile and desktop. 

The scene key has an array containing the three game states. The beginning of the game, prior to the user clicking, the game itself and the game over screen.

```js
const config = {
  type: Phaser.AUTO,
  width: window.innerWidth,
  height: window.innerHeight,
  backgroundColor: "b9eaff",
  physics: {
    default: 'arcade'
  },
  scene: [StartScene, GameScene, EndScene]
}

const game = new Phaser.Game(config)

``` 


### Game Logic

The game logic was fairly straightforward to implement once I had gotten to grips with the variety of basic tools that Phaser provides. 

Below is an example of how straightforward it was to write the logic that moves the player's monkey character. This works for both mouse movement on desktop and swiping interaction on mobile.

```js
   this.input.on('pointermove', function (pointer) {

      this.monkey.x = Phaser.Math.Clamp(pointer.x, 52, window.innerWidth)

      if (this.ball.getData('onMonkey')) {
        this.ball.x = this.monkey.x
      }

    }, this)
    
```

<img  src=assets/Screenshots/StartDesktop1.png width=500> <img  src=assets/Screenshots/StartMobile.png height=250> 


Below is an example of another Phaser-specific feature, collision detection. Which I used to detect collision between the ball and the bananas, removing the banana that was struck and replacing it with a banana peel that is assigned `setGravity` so that it drops directly downwards.

```js
  this.physics.add.collider(this.ball, this.bananas, (ball, banana) => {
      this.sound.play('ballbouncing')
      banana.destroy()
      this.physics.add.sprite(banana.x, banana.y, 'bananapeel').setScale(.05).setGravity(0, 400)
      this.scoreText.setText(`Bananas Left: ${this.bananas.getChildren().length}`)

    })
```


Gravity, velocity and physics are all provided by Phaser, so I won't pore over the specific logic for the whoke game here. The challenge was mostly understanding the framework, rather than writing hugely complicated logic. Do take a look at the source code if you're interested. 


<img  src=assets/Screenshots/GamplayDesktop3.png width=500> <img  src=assets/Screenshots/GamplayMobile2.png height=250> 


## Challenges <img src= assets/tennisball.png height=20 width=20 />
- This was all about learning a simpler way of building a game using the JavaScript language that is more powerful than using plain vanilla JavaScript as per my first project. With this, the biggest challenge was to implement the framework as per Phaser's documentation. 



## Successes <img src= assets/fruit_banana.png height=20 width=20 />

- I'm really pleased with how I was able to make the gaming experience similar on mobile and desktop.

- Understanding the framework and implementing physics was really exciting. 



## Future features <img src= assets/banana_peel.png height=20 width=20 />

I'm going to keep working on this game and adding features when I become more familiar with Phaser. Features I aim to add will include:

- A life system, based on the player's monkey avatar dodging the dropping banana peels. The player will lose a life if they are hit by a falling banana peel.

- A points system based on falling peeled bananas. Some of the falling banana peel will be replaced by a banana which the player can catch for bonus points. 

- A progression system, adding extra scenes that increase the diffifulty if a player completes a level. 


## Credits

Sound effects obtained from [Zapsplat](https://www.zapsplat.com)


<img  src=assets/Screenshots/GameOverDesktop.png> 



### [Play the game now!](https://mjadair.github.io/Monkey-Tennis/)



//
//  Recipe.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 22/07/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

//import Foundation
//import SQLite3
//
//struct Recipe {
//    var id: Int32
//    var content: String
//}
//
//
//
//class RecipeManager {
//    
//    var database: OpaquePointer?
//    static let shared = RecipeManager()
//    private init() {
//        
//    }
//    
//    
//    
//    
//    // RECIPEMANAGER CONNECT METHOD =========================================================
//    func connect() {
//        if database != nil {
//            return
//        }
//        
//        let databaseURL = try! FileManager.default.url(
//            for: .documentDirectory,
//            in: .userDomainMask,
//            appropriateFor: nil,
//            create: false
//        ).appendingPathComponent("recipes.sqlite")
//        
//        if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
//            print("Error opening database")
//            return
//        }
//        
//        if sqlite3_exec(
//            database,
//            """
//            CREATE TABLE IF NOT EXISTS recipes (
//                content TEXT
//            )
//            """,
//            nil,
//            nil,
//            nil
//        ) != SQLITE_OK {
//            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
//        }
//    }
//    
//    
//    
//    // Add new recipe method ============================================================
//    
//    func create() -> Int {
//        connect()
//        
//        var statement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(
//            database,
//            "INSERT INTO recipes (content) VALUES ('This is a recipe!')",
//            -1,
//            &statement,
//            nil
//        ) == SQLITE_OK {
//            if sqlite3_step(statement) != SQLITE_DONE {
//                print("Error inserting note")
//            }
//        }
//        else {
//            print("Error creating note insert statement")
//        }
//        
//        sqlite3_finalize(statement)
//        return Int(sqlite3_last_insert_rowid(database))
//    }
//    
//    
//    
//    // Get/refresh all Recipes ==========================================================
//    
//    func getRecipes() -> [Recipe] {
//        connect()
//        
//        var result: [Recipe] = []
//        var statement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(database, "SELECT rowid, content FROM recipes", -1, &statement, nil) == SQLITE_OK {
//            while sqlite3_step(statement) == SQLITE_ROW {
//                result.append(Recipe(
//                    id: sqlite3_column_int(statement, 0),
//                    content: String(cString: sqlite3_column_text(statement, 1))
//                ))
//            }
//        }
//        
//        sqlite3_finalize(statement)
//        return result
//    }
//    
//    
//    
//    
//    func deleteRecipe(id: Int32) -> Bool {
//        connect()
//        
//        var statement: OpaquePointer!
//        if sqlite3_prepare_v2(database, "DELETE FROM recipes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
//            print("error while preparing sql statement")
//            return false
//        }
//        
//        sqlite3_bind_int(statement, 1, id)
//        
//        if sqlite3_step(statement) != SQLITE_DONE {
//            print("error while trying to delete the recipe")
//            return false
//        }
//        
//        sqlite3_finalize(statement)
//        return true
//    }
//    
//    
//    
//    
//    
//}



