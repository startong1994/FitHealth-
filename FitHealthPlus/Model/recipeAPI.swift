//
//  recipeAPI.swift
//  FitHealthPlus
//
//  Created by Catherine Cheatle on 12/3/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation

class recipeAPI {
    //Shared variable for API results
    static let shared = recipeAPI()
    // Headers for API
    let headers = [
        "x-rapidapi-key": "d700ed82ccmsh8e1056eb6e8e995p12ca59jsn6591285dfa24",
        "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    ]
    
    //function to get a random recipe
    func fetchRandomRecipe(courseString: String, completion: @escaping ([Recipe])-> Void) {

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
                    print("ResponseObject: ", responseObject)
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
    
    // Function to make a API call for a specfic intolerance
    func getIntoleranceSearchResults(queryString: String, completion: @escaping ([Result])-> Void) {
        
        //API request
        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/searchComplex?limitLicense=true&offset=10&number=100&\(queryString)")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // URL session
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                // Print remaining request left in daily quota
                print(httpResponse)
                
                // Get data reponse
                guard let data = data else {
                    print("No data available")
                    completion([])
                    return
                }
                
                //Parse the JSON API data and return the results
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
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
    
    // Function to get a recipe's data via ID
    func getRecipeInformation(id: String, completion: @escaping ([Recipe])-> Void) {
        
        //API request
        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(id)/information?includeNutrition=false")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // URL session
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                // Print remaining request left in daily quota
                print(httpResponse)
                
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
    
    // Function to get nutritional Information by ID
    /*func fetchNutritionByID(id: String, completion: @escaping ([Recipe])-> Void){
        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/1003464/nutritionWidget.json")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
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
                    var nutrition = [Nutrition]()
                    if let nutritionInfo = responseObject as? [String: Any] {
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
    }*/
    
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
    
    // Function to create result array from API query
    func createResults(resultArray: [[String: Any]]) -> [Result] {
        var results = [Result]()
        for resultInfo in resultArray {
            let result = configureResult(resultInfo: resultInfo)
            results.append(result)
        }
        return results
    }
    
    // Function to create a result from API query
    func configureResult(resultInfo: [String: Any]) -> Result {
        var result = Result()
        
        if let id = resultInfo["id"] as? Int {
            result.id = id
        }
        
        if let title = resultInfo["title"] as? String {
            result.title = title
        }
        
        return result
    }
    
    /*//Function to create recipe nutritional info
    func configureNutrition(nutritionInfo: [String: Any]) -> Nutrition {
        var nutrition = Nutrition()
        
        if let goodArray = nutritionInfo["good"] as? [[String: Any]] {
            if goodArray.count == 0 {
                nutrition.good = []
            } else {
                print("Good: " , goodArray)
            }
        }
    }*/
    
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

struct Results{
    var Results: [Result]
}

struct Result {
    var id: Int?
    var title: String?
}


