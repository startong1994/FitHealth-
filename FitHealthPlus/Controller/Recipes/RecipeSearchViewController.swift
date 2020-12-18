//
//  RecipeSearchViewController.swift
//  FitHealthPlus
//
//  Created by Catherine Cheatle on 12/8/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class RecipeSearchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchResultsUIView: UIView!
    
    var results = [Result]()
    var queryString = String()
    var recipe = Recipe()
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.backgroundColor = UIColor.clear
        searchResultsUIView.setTwoGradient(colorOne: UIColor.systemTeal, colorTwo: UIColor.white)
        print("Table View API Query: ", queryString)
    
        
        let recipeResultsFunc = { (getIntoleranceSearchResults: [Result]) in
            self.results = getIntoleranceSearchResults
            self.resultTableView.reloadData()
        }
        
        recipeAPI.shared.getIntoleranceSearchResults(queryString: queryString, completion: recipeResultsFunc)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! resultCell
        let result = results[indexPath.row]
        cell.resultNameLabel.text = result.title
        cell.resultNameLabel.sizeToFit()
        cell.resultNameLabel.numberOfLines=0
        cell.resultNameLabel.textColor = UIColor.white
        //retrieve image from recipe results
        if result.image == "" || result.image == nil {
            cell.recipeImage.image = UIImage(named: "no-image-icon")
        }
        else {
            let imageUrl = URL(string: result.image!)!
            let imageData = try! Data(contentsOf: imageUrl)
            cell.recipeImage.image = UIImage(data: imageData)
        }
        print("Name: ", result.title, " ID: ", result.id)
        cell.resultCellView.layer.cornerRadius = 8
        /*
        cell.resultCellView.layer.cornerRadius = cell.resultCellView.layer.frame.height / 2
        cell.resultCellView.backgroundColor = UIColor.systemTeal
        */
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination.isKind(of: ShowRecipeDetailsViewController.self)){
            let vc = segue.destination as! ShowRecipeDetailsViewController
            if let recipes = sender as? [Recipe]{
                let recipe = recipes.first
                print(recipe)
                vc.getName = recipe?.title! ?? ""
                let recipeInstructions = recipe?.instructions
                
                var newInstructions = recipeInstructions!
                newInstructions.replacingOccurrences(of: "<[^>]+>", with: "")
                vc.getInstructions = newInstructions
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
        let nameString = selectedCell.title!
        print("Selected Title: ", nameString)
        print("Selected ID", idString)
        recipeAPI.shared.getRecipeInformation(id: idString, completion: {
            recipeResult in
            print("Cell selected: ", recipeResult)
            self.performSegue(withIdentifier: "recipeDetail", sender: recipeResult)
        })
    }

}

// Class of Results Cells
class resultCell: UITableViewCell{
    @IBOutlet weak var resultCellView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var resultNameLabel: UILabel!
    
}
