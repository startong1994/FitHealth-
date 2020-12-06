//
//  ShowRecipeDetailsViewController.swift
//  
//
//  Created by Catherine Cheatle on 12/5/20.
//

import UIKit

class ShowRecipeDetailsViewController: UIViewController {
    
    //Labels
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipePrepTimeLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var recipeNutriLabel: UILabel!
    @IBOutlet weak var recipeIngredLabel: UILabel!
    @IBOutlet weak var recipeInstructLabel: UILabel!
    @IBOutlet weak var showNutriBtn: UIButton!
    
    // variables to get recipe information from the Recipe Main Page
    var getName = String()
    var getPrepTime = Int()
    var getServingSize = Int()
    var getIngredients = String()
    var getInstructions = String()
    
    //done button
    @IBAction func doneBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set labels to recipe information
        print("Name label:", getName)
        recipeNameLabel.text = getName
        print(getPrepTime)
        recipePrepTimeLabel.text = "Cooking Time: " + String(getPrepTime) + " minutes"
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
    }

}
