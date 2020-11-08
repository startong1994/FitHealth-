//
//  PantryItemList.swift
//  PantryList
//
//  Created by Catherine Cheatle on 10/18/20.
//  Copyright © 2020 Catherine Cheatle. All rights reserved.
//

import Foundation

class PantryItemList: NSObject, NSCoding{
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
    }
