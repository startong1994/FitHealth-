//
//  recipeAPI.swift
//  FitHealthPlus
//
//  Created by Catherine Cheatle on 12/3/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation

class recipeAPI {
    static let shared = recipeAPI()
    //function to get a random recipe
    func fetchRandomRecipe(courseString: String, completion: @escaping ([Recipe])-> Void) {

        let headers = [
            "x-rapidapi-key": "d700ed82ccmsh8e1056eb6e8e995p12ca59jsn6591285dfa24",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/random?number=1&tags=vegetarian%2C\(courseString)")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                completion([])
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                guard let data = data else {
                    print("No data available")
                    completion([])
                    return
                }
                
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    if let recipeArray = responseObject?["recipes"] as? [[String: Any]] {
                        let recipes = self.createRecipes(recipeArray: recipeArray)
                        DispatchQueue.main.async {
                            completion(recipes)
                        }
                        
                    } else {
                        completion([])
                    }
                } catch{
                    let error = error
                    print("Cant decode data")
                    print(error.localizedDescription)
                    completion([])
                }
            }
        })
        dataTask.resume()
    }
    
    func createRecipes(recipeArray: [[String: Any]]) -> [Recipe] {
        var recipes = [Recipe]()
        for recipeInfo in recipeArray {
            let recipe = configureRecipe(recipeInfo: recipeInfo)
            recipes.append(recipe)
        }
        return recipes
    }
    
    func configureRecipe(recipeInfo: [String: Any]) -> Recipe {
        var recipe = Recipe()
        
        if let title = recipeInfo["title"] as? String {
            recipe.title = title
        }
        
        if let image = recipeInfo["image"] as? String {
            recipe.image = image
        }
        
        if let servings = recipeInfo["servings"] as? Int {
            recipe.servings = servings
        }
        
        if let readyInMinutes = recipeInfo["readyInMinutes"] as? Int {
            recipe.readyInMinutes = readyInMinutes
        }
        
        if let instructions = recipeInfo["instructions"] as? String {
            recipe.instructions = instructions
        }
        
        if let ingredientArray = recipeInfo["extendedIngredients"] as? [[String: Any]] {
            if ingredientArray.count == 0 {
                recipe.extendedIngredients = []
            } else {
                var ingredients = [String]()
                for ingredient in ingredientArray {
                    if let ingredient = ingredient["originalString"] as? String {
                        ingredients.append(ingredient)
                    }
                }
                recipe.extendedIngredients = ingredients
            }
        }else {
            recipe.extendedIngredients = []
        }
        
        return recipe
    }
    
}

struct Recipes {
    var recipes: [Recipe]
}

struct Recipe {
    var title: String?
    var image: String?
    var servings: Int?
    var readyInMinutes: Int?
    var extendedIngredients: [String]?
    var instructions: String?
}


