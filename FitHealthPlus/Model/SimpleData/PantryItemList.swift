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
            static var nutriInfo = "nutriInfo"
        }
        
        var quantity: Int
        var name: String
        var exDate: String
        var category: String
        var calorie: Int
        var nutriInfo: String
    
    init(quantity: Int, name: String, exDate: String, category: String, calorie: Int, nutriInfo: String) {
            self.quantity = quantity
            self.category = category
            self.name = name
            self.exDate = exDate
            self.calorie = calorie
            self.nutriInfo = nutriInfo
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(quantity, forKey: key.quantity)
            aCoder.encode(name, forKey: key.name)
            aCoder.encode(exDate, forKey: key.exDate)
            aCoder.encode(category, forKey: key.category)
            aCoder.encode(calorie, forKey: key.calorie)
            aCoder.encode(nutriInfo, forKey: key.nutriInfo)
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            let numOfItems = aDecoder.decodeInteger(forKey: key.quantity)
            let nameOfItems = aDecoder.decodeObject(forKey: key.name) as? String
            let exDatesOfItems = aDecoder.decodeObject(forKey: key.exDate) as? String
            let categoriesOfItems = aDecoder.decodeObject(forKey: key.category) as? String
            let caloriesOfItems = aDecoder.decodeInteger(forKey: key.calorie)
            let nutriInfoOfItems = aDecoder.decodeObject(forKey: key.nutriInfo) as? String
            
            self.init(quantity: numOfItems, name: nameOfItems!, exDate: exDatesOfItems!, category: categoriesOfItems!, calorie: caloriesOfItems, nutriInfo: nutriInfoOfItems!)
        }
        
        static let filePathToDocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        static let stuffFolder = filePathToDocumentDirectory.appendingPathComponent("pantryList")
    }
