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
    
    var results = [Result]()
    var recipeDetails = Recipe()
    var recipeString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTableView.delegate = self
        searchBarTableView.dataSource = self
        searchBarTableView.backgroundColor = UIColor.clear
        searchBarResultsUIView.setTwoGradient(colorOne: UIColor.systemTeal, colorTwo: UIColor.white)
        
        let resultsFunc = {( getTheResults: [Result]) in
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
            let imageUrl = URL(string: result.image!)!
            let imageData = try! Data(contentsOf: imageUrl)
            cell.recipeImage.image = UIImage(data: imageData)
        }

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


class SearchBarResultsCell: UITableViewCell{
    
    @IBOutlet weak var recipeCellView: UIView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
}

