//
//  RecipeMainViewController.swift
//  FitHealthPlus
//
//  Created by Catherine Cheatle on 11/28/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class RecipeMainViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //Page Components
    @IBOutlet weak var myRecipesBtn: UIButton!
    @IBOutlet weak var randomDish1Btn: UIButton!
    @IBOutlet weak var randomDish2Btn: UIButton!
    @IBOutlet weak var randomDish3Btn: UIButton!
    @IBOutlet weak var mainPageView: UIView!
    @IBOutlet weak var dietCollectionView: UICollectionView!
    @IBOutlet weak var mainCategoryCollectionView: UICollectionView!
    @IBAction func breakfastBtnPressed(_ sender: UIButton) {
        recipeAPI.shared.fetchRandomRecipe(courseString: "breakfast",completion: { result in
            print("Button Pressed: ", result)
            self.performSegue(withIdentifier: "randomMeal", sender: result)
        })
    }
    @IBAction func lunchBtnPressed(_ sender: UIButton) {
        recipeAPI.shared.fetchRandomRecipe(courseString: "lunch",completion: { result in
            print("Button Pressed: ", result)
            self.performSegue(withIdentifier: "randomMeal", sender: result)
        })
    }
    
    @IBAction func dinnerBtnPressed(_ sender: UIButton) {
        recipeAPI.shared.fetchRandomRecipe(courseString: "dessert",completion: { result in
            print("Button Pressed: ", result)
            self.performSegue(withIdentifier: "randomMeal", sender: result)
        })
    }
    //Image and name Arrays for the Diet Categories
    var dietRestrictions = [UIImage(named: "lactose-free")!, UIImage(named: "gluten-free")!, UIImage(named: "nut-free")!, UIImage(named: "shellfish")!, UIImage(named: "vegetarian")!, UIImage(named: "salad")!, UIImage(named: "fish")!, UIImage(named: "ketogenic-diet")!]
    var dietName = ["Dairy Free", "Gluten Free", "Peanut Free", "Shellfish Free", "Vegetarian", "Vegan", "Pescetarian", "Ketogenic"]
    
    //Image and Name Arrays for Main Category Collection View
    var mainCategoryRestrictions = [UIImage(named: "breakfast")!, UIImage(named: "appetizer")!, UIImage(named: "lunch-bag")!, UIImage(named: "sweets")!, UIImage(named: "turkey")!, UIImage(named: "meat")!, UIImage(named: "chop")!, UIImage(named: "seafood")!]
    var mainCategoryName = ["Breakfast", "Appetizers", "Main Course", "Desserts", "Poultry", "Beef", "Pork", "Seafood"]
    
    //Recipe API
    var recipesList = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dietCollectionView.delegate = self
        dietCollectionView.dataSource = self
        mainCategoryCollectionView.delegate = self
        mainCategoryCollectionView.dataSource = self
        
        myRecipesBtn.layer.cornerRadius = 20
        randomDish1Btn.layer.cornerRadius = 0.5 * randomDish1Btn.bounds.size.width
        randomDish2Btn.layer.cornerRadius = 0.5 * randomDish2Btn.bounds.size.width
        randomDish3Btn.layer.cornerRadius = 0.5 * randomDish3Btn.bounds.size.width
        randomDish1Btn.clipsToBounds = true
        randomDish2Btn.clipsToBounds = true
        mainPageView.setTwoGradient(colorOne: UIColor.systemTeal, colorTwo: UIColor.white)
        dietCollectionView.backgroundColor = UIColor.clear
        mainCategoryCollectionView.backgroundColor = UIColor.clear
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        //searchController.navigationItem.hidesSearchBarWhenScrolling = true
        let searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchController.searchBar.delegate = self
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemTeal
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.dietCollectionView {
            return dietRestrictions.count
        }
        
        return mainCategoryName.count
    }
    
    //Collection views for diet and intolerances
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.dietCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dietCategoryCell", for: indexPath) as! dietCategoryCollectionViewCell
            cell.dietCategoryImage.contentMode = .scaleAspectFit
            cell.dietCategoryImage.clipsToBounds = true
            cell.dietCategoryImage.image = dietRestrictions[indexPath.row]
            cell.dietCategoryLabel.text = dietName[indexPath.row]
            return cell
        }
        
        else{
            let mcell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCategoryCell", for: indexPath) as! mainCategoryCollectionViewCell
            mcell.mainCategoryLabel.text = mainCategoryName[indexPath.row]
            mcell.mainCategoryImage.contentMode = .scaleAspectFit
            mcell.mainCategoryImage.clipsToBounds = true
            mcell.mainCategoryImage.image = mainCategoryRestrictions[indexPath.row]
            //mcell.backgroundColor = UIColor.systemBlue
            mcell.layer.cornerRadius = 20
            return mcell
        }
    }
    
    // Collection view to see what cell was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.dietCollectionView {
            print(dietName[indexPath.row], " has been selected")
            var diet = dietName[indexPath.row]
            //"Dairy Free", "Gluten Free", "Peanut Free", "Shellfish Free, "Vegetarian", "Vegan", "Pescetarian", "Ketogenic" needs to be modified for API query
            if (diet == "Dairy Free"){
                diet = "intolerances=dairy"
            }
            if (diet == "Gluten Free"){
                diet = "intolerances=gluten"
            }
            if (diet == "Peanut Free"){
                diet = "intolerances=peanut"
            }
            if (diet == "Shellfish Free"){
                diet = "intolerances=shellfish"
            }
            if (diet == "Vegetarian"){
                diet = "diet=vegetarian"
            }
            if (diet == "Vegan" ){
                diet = "diet=vegan"
            }
            if (diet == "Pescetarian" ){
                diet = "diet=pescetarian"
            }
            if (diet == "Ketogenic" ){
                diet = "diet=ketogenic"
            }
            print("Query String: ", diet)
            let vc = storyboard?.instantiateViewController(withIdentifier: "searchResults") as? RecipeSearchViewController
            vc?.queryString = diet
            self.navigationController?.pushViewController(vc!, animated: true)
        } else{
            print(mainCategoryName[indexPath.row], " has been selected")
            var category = mainCategoryName[indexPath.row]
            //"Breakfast", "Appetizers", "Main Course", "Desserts", "Poultry", "Beef", "Pork", "Seafood" needs to be modified for API query
            if (category == "Breakfast"){
                category = "type=breakfast"
            }
            if (category == "Appetizers"){
                category = "type=appetizer"
            }
            if (category == "Main Course"){
                category = "type=main%20course"
            }
            if (category == "Desserts"){
                category = "type=dessert"
            }
            if (category == "Poultry"){
                category = "type=poultry"
            }
            if (category == "Beef" ){
                category = "type=beef"
            }
            if (category == "Pork" ){
                category = "type=pork"
            }
            if (category == "Seafood" ){
                category = "type=seafood"
            }
            print("Query String:", category)
            let vc = storyboard?.instantiateViewController(withIdentifier: "searchResults") as? RecipeSearchViewController
            vc?.queryString = category
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    // Segue for Breakfast Random Meal
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination.isKind(of: ShowRecipeDetailsViewController.self)){
            let vc = segue.destination as! ShowRecipeDetailsViewController
            if let recipes = sender as? [Recipe] {
                let recipe = recipes.first
                print(recipe)
                vc.getName = recipe?.title! ?? ""
                vc.getInstructions = recipe?.instructions! ?? "Instructions not available"
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
    
    func handleRecipe(recipes: [Recipe]){
        DispatchQueue.main.async {
            self.recipesList = recipes
            print("In handler: ", self.recipesList)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBarText = searchBar.text else {return}
        if searchBarText != "" || searchBarText != nil {
            let recipeString = searchBarText.replacingOccurrences(of: " ", with: "%20")
            let resultsTableView = storyboard?.instantiateViewController(withIdentifier: "searchBarResults") as? RecipeSearchBarViewController
            resultsTableView?.recipeString = recipeString
            self.navigationController?.pushViewController(resultsTableView!, animated: true)
            
        }
       
        
        
    }

}

extension UIView {
    public func setTwoGradient(colorOne: UIColor, colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

class dietCategoryCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var dietCategoryImage: UIImageView!
    @IBOutlet weak var dietCategoryLabel: UILabel!
}

class mainCategoryCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var mainCategoryImage: UIImageView!
    @IBOutlet weak var mainCategoryLabel: UILabel!
}
