//
//  ShowRecipeDetailsViewController.swift
//  FitHealthPlus
//
//  Created by Catherine Cheatle on 12/6/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase

class ShowRecipeDetailsViewController: UIViewController {
    
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    let categoryType = GetCategory()
    
    //Labels
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipePrepTimeLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var recipeNutriLabel: UILabel!
    @IBOutlet weak var recipeIngredLabel: UILabel!
    @IBOutlet weak var recipeInstructLabel: UILabel!
    //@IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func saveRecipeButton(_ sender: UIBarButtonItem) {
        saveSearchedRecipe()
        dismiss(animated: true, completion: nil)
    }
    
    // variables to get recipe information from the Recipe Main Page
    var getName = String()
    var getPrepTime = Int()
    var getServingSize = Int()
    var getIngredients = String()
    var getInstructions = String()
    var getImage = String()
    
    
    //done button
    @IBAction func doneBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set labels to recipe information
        recipeNameLabel.sizeToFit()
        recipeNameLabel.numberOfLines = 0
        print("Name label:", getName)
        recipeNameLabel.text = getName
        print(getPrepTime)
        recipePrepTimeLabel.text = "Ready in (min): " + String(getPrepTime) + " minutes"
        print(getServingSize)
        servingSizeLabel.text = "Serving Size: " + String(getServingSize)
        print(getIngredients)
        print(getInstructions)
        recipeInstructLabel.sizeToFit()
        recipeIngredLabel.sizeToFit()
        recipeIngredLabel.numberOfLines = 0
        recipeInstructLabel.numberOfLines = 0
        recipeIngredLabel.text = getIngredients
        recipeInstructLabel.text = getInstructions
        let recipeUrl = String(getImage)
        if recipeUrl == "" || recipeUrl == nil {
            recipeImageView.image = UIImage(named: "no-image-icon")
        }
        else {
            let recipeUrl = URL(string: String(getImage))!
            let imageData = try! Data(contentsOf: recipeUrl)
            recipeImageView.image = UIImage(data: imageData)
        }
        //^^^^^done retrieving image
    }
    
    func saveSearchedRecipe() {
        let recipeName = getName
        let imageURL = getImage
        //To get category via name
        let category = categoryType.getRecipeCategory (recipeName: getName)
        let servings = String(getServingSize)
        let cookTime = String(getPrepTime)
        let ingredients = getIngredients
        let directions = getInstructions

        
        //gets user's name for database
        guard let name = defaults.dictionary(forKey: "CurrentUser")!["email"] else{
            return
        }
        
        let recipeRef = db.collection("Recipe").document(name as! String).collection("My Recipes")
        
        // adds recipe info to the database
        recipeRef.document(recipeName).setData([
            "recipeImg": imageURL,
            "name": recipeName,
            "category": category,
            "servings": servings,
            "cookTime": cookTime,
            "ingredients": ingredients,
            "directions": directions,

        ])
    }

}

class GetCategory {

    func getRecipeCategory (recipeName: String?) -> String {
        
        let poultry = ["chicken", "turkey", "duck", "fowl", "hen", "poultry"]
        let seafood = ["seafood","fish", "shrimp", "scallop", "mussel", "clam", "oyster", "lobster", "crab", "salmon", "tuna", "tilapia",
                      "catfish", "cod", "mahi-mahi", "mahi mahi", "trout", "flounder", "snapper", "sardine", "herring", "grouper",
                      "mackerel", "pollock", "sea bass", "sword fish", "halibut", "pike", "monkfish"]
        let beef = ["steak", "veal", "oxtail","beef"]
        let pork = ["pork", "ham", "prosciutto"]
        
        let lowercasedTitle = recipeName?.lowercased() ?? ""
        var check = ""
  
        for category1 in poultry {
            if lowercasedTitle.contains(category1) {
                check = "Poultry"
            }
            print(check)
        }
        for category2 in seafood {
            if lowercasedTitle.contains(category2) {
                check = "Seafood"
            }
        }
        for category3 in beef {
            if lowercasedTitle.contains(category3) {
                check = "Beef"
            }
        }
        for category4 in pork {
            if lowercasedTitle.contains(category4) {
                check = "Pork"
            }
        }
        
        if check == "" {
            check = "Other"
        }
        
        return check
    }
    
}
