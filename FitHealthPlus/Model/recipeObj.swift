//
//  recipeObj.swift
//  FitHealthPlus
//
//  Created by Fayliette Lewis on 11/20/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import Foundation
import Firebase

struct recipeItem {
    let recipeImg: String?
    let name: String
    let cookTime: String
    let servings: String
    let category: String
    let ingredients: String
    let directions: String
    let calories: Int
    let fat: Int
    let sodium: Int
    let carb: Int
    let fiber: Int
    let sugar: Int
    let protein: Int
    let cholesterol: Int
    
    
    
    var recipeDictionary : [String: Any] {
        return [
            "recipeImg": recipeImg,
            "name": name,
            "cookTime": cookTime,
            "servings": servings,
            "category": category,
            "ingredients": ingredients,
            "directions": directions,
            "calories": calories,
            "fat": fat,
            "sodium": sodium,
            "carb": carb,
            "fiber": fiber,
            "sugar": sugar,
            "protein": protein,
            "cholesterol": cholesterol
        ]
    }
}

extension recipeItem {
    init?(recipeDictionary : [String:Any]){
       guard let recipeImg = recipeDictionary["recipeImg"] as? String,
             let name = recipeDictionary["name"] as? String,
             let cookTime = recipeDictionary["cookTime"] as? String,
             let servings = recipeDictionary["servings"] as? String,
             let category = recipeDictionary["category"] as? String,
             let ingredients = recipeDictionary["ingredients"] as? String,
             let directions = recipeDictionary["directions"] as? String,
             let calories = recipeDictionary["calories"] as? Int,
             let fat = recipeDictionary["fat"] as? Int,
             let sodium = recipeDictionary["sodium"] as? Int,
             let carb = recipeDictionary["carb"] as? Int,
             let fiber = recipeDictionary["fiber"] as? Int,
             let sugar = recipeDictionary["sugar"] as? Int,
             let protein = recipeDictionary["protein"] as? Int,
             let cholesterol = recipeDictionary["cholesterol"] as? Int else {return nil}
        
        
        self.init(recipeImg: recipeImg,
                  name: name,
                  cookTime: cookTime,
                  servings: servings,
                  category: category,
                  ingredients: ingredients,
                  directions:directions,
                  calories: calories,
                  fat: fat,
                  sodium: sodium,
                  carb: carb,
                  fiber: fiber,
                  sugar: sugar,
                  protein:protein,
                  cholesterol: cholesterol)
    }
}

