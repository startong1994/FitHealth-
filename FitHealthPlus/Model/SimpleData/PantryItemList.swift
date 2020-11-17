//
//  PantryItemList.swift
//  PantryList
//
//  Created by Catherine Cheatle on 10/18/20.
//  Copyright © 2020 Catherine Cheatle. All rights reserved.
//

import Foundation
import Firebase

/*class PantryItemList: NSObject, NSCoding{
        struct key{
            static var quantity = "quantity"
            static var name = "name"
            static var exDate = "exDate"
            static var category = "category"
            static var calorie = "calorie"
        }
        
        var quantity: Int
        var name: String
        var exDate: String
        var category: String
        var calorie: Int
    
    init(quantity: Int, name: String, exDate: String, category: String, calorie: Int) {
            self.quantity = quantity
            self.category = category
            self.name = name
            self.exDate = exDate
            self.calorie = calorie
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(quantity, forKey: key.quantity)
            aCoder.encode(name, forKey: key.name)
            aCoder.encode(exDate, forKey: key.exDate)
            aCoder.encode(category, forKey: key.category)
            aCoder.encode(calorie, forKey: key.calorie)
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            let numOfItems = aDecoder.decodeInteger(forKey: key.quantity)
            let nameOfItems = aDecoder.decodeObject(forKey: key.name) as? String
            let exDatesOfItems = aDecoder.decodeObject(forKey: key.exDate) as? String
            let categoriesOfItems = aDecoder.decodeObject(forKey: key.category) as? String
            let caloriesOfItems = aDecoder.decodeInteger(forKey: key.calorie)
            
            self.init(quantity: numOfItems, name: nameOfItems!, exDate: exDatesOfItems!, category: categoriesOfItems!, calorie: caloriesOfItems)
        }
    
    
    static let filePathToDocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let stuffFolder = filePathToDocumentDirectory.appendingPathComponent("pantryItemList")
}*/

struct PantryItem {
    let name: String
    let quantity: Int
    let exDate: String
    let category: String
    let servingSize: String
    let calories: Int
    let fat: Int
    let sodium: Int
    let carb: Int
    let fiber: Int
    let sugar: Int
    let protein: Int
    let cholestrol: Int
    
    var pantryDictionary : [String: Any] {
        return [
            "name": name,
            "quantity": quantity,
            "exDate": exDate,
            "category": category,
            "servingSize": servingSize,
            "calories": calories,
            "fat": fat,
            "sodium": sodium,
            "carb": carb,
            "fiber": fiber,
            "sugar": sugar,
            "protein": protein,
            "cholestrol": cholestrol
        ]
    }
}

extension PantryItem {
    init?(pantryDictionary : [String:Any]){
       guard let name = pantryDictionary["name"] as? String,
             let quantity = pantryDictionary["quantity"] as? Int,
             let exDate = pantryDictionary["exDate"] as? String,
             let category = pantryDictionary["category"] as? String,
             let servingSize = pantryDictionary["servingSize"] as? String,
             let calories = pantryDictionary["calories"] as? Int,
             let fat = pantryDictionary["fat"] as? Int,
             let sodium = pantryDictionary["sodium"] as? Int,
             let carb = pantryDictionary["carb"] as? Int,
             let fiber = pantryDictionary["fiber"] as? Int,
             let sugar = pantryDictionary["sugar"] as? Int,
             let protein = pantryDictionary["protein"] as? Int,
             let cholestrol = pantryDictionary["cholestrol"] as? Int else {return nil}
        
        self.init(name: name,
                  quantity: quantity,
                  exDate: exDate,
                  category: category,
                  servingSize: servingSize,
                  calories: calories,
                  fat: fat,
                  sodium: sodium,
                  carb: carb,
                  fiber: fiber,
                  sugar: sugar,
                  protein:protein,
                  cholestrol: cholestrol)
    }
}
