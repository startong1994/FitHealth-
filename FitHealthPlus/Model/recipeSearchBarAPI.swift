//
//  recipeSearchBarAPI.swift
//  FitHealthPlus
//
//  Created by Fayliette Lewis on 12/12/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation

class recipeSearchBarAPI {
    
    //Shared variable for API results
    static let shared = recipeSearchBarAPI()
    
    //API headers
    let headers = [
        "x-rapidapi-key": "3d2e3c9b2dmsh6ce3f9413c93b7ep1b5689jsn241f9ea9f3d1",
        "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    ]
    
    func getRecipeSearchResults (recipeString: String, completion: @escaping ([RecipeResults]) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?query=\(recipeString)&number=5&offset=0")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // URL session
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                // Print remaining request left in daily quota
                print(httpResponse!)
                
                // Get data reponse
                guard let data = data else {
                    print("No data available")
                    completion([])
                    return
                }
                
                //Parse the JSON API data and return the results
                do {
                    
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    print("Response Object: ", responseObject!)
                    if let resultArray = responseObject?["results"] as? [[String: Any]] {
                        let results = self.createResults(resultArray: resultArray)
                        DispatchQueue.main.async {
                            completion(results)
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
    
    // Function to create result array from API query
    func createResults(resultArray: [[String: Any]]) -> [RecipeResults] {
        var results = [RecipeResults]()
        for resultInfo in resultArray {
            let result = configureResult(resultInfo: resultInfo)
            results.append(result)
        }
        return results
    }
    
    // Function to create a result from API query
    func configureResult(resultInfo: [String: Any]) -> RecipeResults {
        var result = RecipeResults()
        
        if let id = resultInfo["id"] as? Int {
            result.id = id
        }
        
        if let title = resultInfo["title"] as? String {
            result.title = title
        }
        
        if let image = resultInfo["image"] as? String {
            result.image = image
        }
        
        return result
    }
    
    
    func getRecipeInfoFromId (recipeID: String, completion: @escaping ([Recipe]) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(recipeID)/information?includeNutrition=false")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // URL session
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                // Print remaining request left in daily quota
                print(httpResponse!)
                
                // Get data reponse
                guard let data = data else {
                    print("No data available")
                    completion([])
                    return
                }
                
                //Parse the JSON API data and return the results
                do {
                    
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    print("Response Object: ", responseObject)
                    var recipes = [Recipe]()
                    if let recipeInfo = responseObject as? [String: Any] {
                        let recipe = self.configureRecipe(recipeInfo: recipeInfo)
                        recipes.append(recipe)
                        DispatchQueue.main.async {
                            print("Recipe from ID: ", recipe)
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
    
    // Function to create recipe array
    func createRecipes(recipeArray: [[String: Any]]) -> [Recipe] {
        var recipes = [Recipe]()
        for recipeInfo in recipeArray {
            let recipe = configureRecipe(recipeInfo: recipeInfo)
            recipes.append(recipe)
        }
        return recipes
    }
    
    // Function to create a recipe from API query
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
        
struct searchResults {
    var results: [RecipeResults]
    var baseUri: String?
}

struct RecipeResults {
    var id: Int?
    var title: String?
    var image: String?
    
}





