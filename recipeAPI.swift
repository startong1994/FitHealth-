//
//  recipeAPI.swift
//  FitHealthPlus
//
//  Created by Catherine Cheatle on 12/3/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation

final class recipeAPI {
    
    static let shared = recipeAPI()
    
    //function to get a random recipe
    func fetchRandomRecipe() {
        
        /*//URL
        let urlString = URL(string: "https://api.spoonacular.com/recipes/random")
        guard urlString != nil else {
            print("Error creating URL object")
            return
        }
        
        //URL Request
        var request = URLRequest(url: urlString!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        //Specify the header
        let headers = [
            "x-rapidapi-key": "d700ed82ccmsh8e1056eb6e8e995p12ca59jsn6591285dfa24",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        //Get URLSession
        let session = URLSession.shared
        // Creat Data Task
        let dataTask = session.dataTask(with: request) { (data,response, error) in
            
            guard let data = data else {
                print("data was nil")
                return
            }
            
            guard let recipe = try? JSONDecoder().decode(Recipe.self, from: data) else{
                print(data)
                print("could not decode json")
                return
            }
            
            print(recipe)
        }

        dataTask.resume()
    }*/

        let headers = [
            "x-rapidapi-key": "d700ed82ccmsh8e1056eb6e8e995p12ca59jsn6591285dfa24",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/random?number=1&tags=vegetarian%2Cdessert")! as URL,
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
            }
        })

        dataTask.resume()
    }
    
}

struct RecipeIngredients: Codable {
    let name: String
    let originalString: String
}
struct Recipe: Codable {
    let title: String?
    let image: String?
    let servings: Int?
    let extendedIngredients: RecipeIngredients?
}
