//
//  ingredientAPI.swift
//  FitHealthPlus
//
//  Created by Catherine Cheatle on 12/17/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation

class ingredientAPI{
    //shared variable for API results
    static let sharedIngredientResult = ingredientAPI()
    
    //API request
    func fetchIngredients(queryString: String, completion: @escaping ([Item]) -> Void){
        let headers = [
            "x-rapidapi-key": "d700ed82ccmsh8e1056eb6e8e995p12ca59jsn6591285dfa24",
            "x-rapidapi-host": "calorieninjas.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://calorieninjas.p.rapidapi.com/v1/nutrition?query=\(queryString)")! as URL,
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
                
                //get data
                guard let data = data else{
                    print("No Data available")
                    completion([])
                    return
                }
                
                //Parse JSON API data and return results
                do{
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    print("Response Object: ", responseObject)
                    if let resultArray = responseObject?["items"] as? [[String: Any]]{
                        let results = self.createItems(itemArray: resultArray)
                        print(results)
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
    
    // Function to create array for item objects from API
    func createItems(itemArray: [[String: Any]]) -> [Item] {
        var items = [Item]()
        for itemInfo in itemArray {
            let item = configureItem(itemInfo: itemInfo)
            items.append(item)
        }
        
        return items
    }
    
    //Function to configure item object from json api data
    func configureItem(itemInfo: [String: Any]) -> Item {
        var item = Item()
        
        if let sugar_g = itemInfo["sugar_g"] as? Double {
            item.sugar_g = sugar_g
        }
        
        if let fiber_g = itemInfo["fiber_g"] as? Double {
            item.fiber_g = fiber_g
        }
        
        if let serving_size_g = itemInfo["serving_size_g"] as? Double {
            item.serving_size_g = serving_size_g
        }
        
        if let sodium_mg = itemInfo["sodium_mg"] as? Double {
            item.sodium_mg = sodium_mg
        }
        
        if let name = itemInfo["name"] as? String {
            item.name = name
        }
        
        if let fat_total_g = itemInfo["fat_total_g"] as? Double {
            item.fat_total_g = fat_total_g
        }
        
        if let calories = itemInfo["calories"] as? Double {
            item.calories = calories
        }
        
        if let cholesterol_mg = itemInfo["cholesterol_mg"] as? Double {
            item.cholesterol_mg = cholesterol_mg
        }
        
        if let protein_g = itemInfo["protein_g"] as? Double {
            item.protein_g = protein_g
        }
        
        if let carbohydrates_total_g = itemInfo["carbohydrates_total_g"] as? Double {
            item.carbohydrates_total_g = carbohydrates_total_g
        }
        
        return item
    }
}



//Structs for JSON results
struct Items {
    var Items: [Item]
}

struct Item {
    var sugar_g: Double?
    var fiber_g: Double?
    var serving_size_g: Double?
    var sodium_mg: Double?
    var name: String?
    var fat_total_g: Double?
    var calories: Double?
    var cholesterol_mg: Double?
    var protein_g: Double?
    var carbohydrates_total_g: Double?
}

