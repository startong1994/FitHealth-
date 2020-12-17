//
//  RecipeSearchBarViewController.swift
//  FitHealthPlus
//
//  Created by Fayliette Lewis on 12/13/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class RecipeSearchBarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBarResultsUIView: UIView!
    @IBOutlet weak var searchBarTableView: UITableView!
    
    var results = [RecipeResults]()
    var recipeDetails = Recipe()
    var recipeString = String()
    let imageBaseURL = "https://spoonacular.com/recipeImages/"
    let category = GetCategory()
    var count = 1
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTableView.delegate = self
        searchBarTableView.dataSource = self
        searchBarTableView.backgroundColor = UIColor.clear
        searchBarResultsUIView.setTwoGradient(colorOne: UIColor.systemTeal, colorTwo: UIColor.white)
        
        let resultsFunc = {( getTheResults: [RecipeResults]) in
            self.results = getTheResults
            self.searchBarTableView.reloadData()
        }
        recipeSearchBarAPI.shared.getRecipeSearchResults(recipeString: recipeString, completion: resultsFunc)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarResultsCell", for: indexPath) as! SearchBarResultsCell
        cell.recipeCellView.layer.cornerRadius = 8
        let result = results[indexPath.row]
        cell.recipeName.text = result.title
        //retrieve image from recipe results
        if result.image == "" || result.image == nil {
            cell.recipeImage.image = UIImage(named: "no-image-icon")
        }
        else {
            let imageUrl = URL(string: imageBaseURL+result.image!)!
            let imageData = try! Data(contentsOf: imageUrl)
            cell.recipeImage.image = UIImage(data: imageData)
        }
        //to get recipe category
        let title = result.title
        cell.recipeCategory.text = category.getRecipeCategory (recipeName: title)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination.isKind(of: ShowRecipeDetailsViewController.self)){
            let vc = segue.destination as! ShowRecipeDetailsViewController
            if let recipes = sender as? [Recipe]{
                let recipe = recipes.first
                vc.getName = recipe?.title! ?? ""
                let recipeInstructions = recipe?.instructions
                var newInstructions = recipeInstructions
                newInstructions?.replacingOccurrences(of: "<[^>]+>", with: "\n")
                vc.getInstructions = recipe?.instructions ?? ""
                vc.getInstructions = newInstructions ?? ""
                vc.getPrepTime = recipe?.readyInMinutes! ?? 0
                vc.getServingSize = recipe?.servings! ?? 0
                vc.getImage = recipe?.image! ?? ""
                var ingredientsList = ""
                for ingredient in recipe?.extendedIngredients ?? []{
                    ingredientsList += ingredient + "\n"
                }
                
                vc.getIngredients = ingredientsList
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = results[indexPath.row]
        let idString = String(selectedCell.id!)

        recipeSearchBarAPI.shared.getRecipeInfoFromId(recipeID: idString, completion: {
            recipeResults in
            self.performSegue(withIdentifier: "SearchBarResult", sender: recipeResults)
        })
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

class SearchBarResultsCell: UITableViewCell{
    
    @IBOutlet weak var recipeCellView: UIView!
    @IBOutlet weak var recipeCategory: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
}

