//
//  Recipe.swift
//  RecipeScrapBook
//
//  Created by Michael Adair on 22/07/2020.
//  Copyright © 2020 Michael Adair. All rights reserved.
//

import Foundation
import SQLite3

struct Recipe {
    var id: Int32
    var content: String
}



class RecipeManager {
    
    
    var database: OpaquePointer?
    
    static let shared = RecipeManager()
    
    private init() {
    }
    
    
    
    
    // RECIPEMANAGER CONNECT METHOD =========================================================
    func connect() {
        if database != nil {
            return
        }
        
        let databaseURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("recipes.sqlite")
        
        if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        if sqlite3_exec(
            database,
            """
            CREATE TABLE IF NOT EXISTS recipes (
                content TEXT
            )
            """,
            nil,
            nil,
            nil
        ) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }
    
    
    
    // Add new recipe method ============================================================
    
    func create() -> Int {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO recipes (content) VALUES ('This is a recipe!')",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting note")
            }
        }
        else {
            print("Error creating note insert statement")
        }
        
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    
    
    // Get/refresh all Recipes ==========================================================
    
    func getRecipes() -> [Recipe] {
        connect()
        
        var result: [Recipe] = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT rowid, content FROM recipes", -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                result.append(Recipe(
                    id: sqlite3_column_int(statement, 0),
                    content: String(cString: sqlite3_column_text(statement, 1))
                ))
            }
        }
        
        sqlite3_finalize(statement)
        return result
    }
    
    
    
    
    
}
