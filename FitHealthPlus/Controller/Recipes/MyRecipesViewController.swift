//
//  MyRecipesViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/22/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MyRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableViewContainerUIView: UIView!
    @IBOutlet weak var recipeTableView: UITableView!

    // View for sort feature
    var containerView = UIView()
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    // Variables
    var listRecipes = [recipeItem]()
    var searchingItems = [recipeItem]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Recipes"
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        setUpSearchBar()
        recipeTableView.backgroundColor = UIColor.clear
        tableViewContainerUIView.setTwoGradient(colorOne: UIColor.systemTeal, colorTwo: UIColor.white)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    
        //code to get data from user that's logged in
        guard let username = defaults.dictionary(forKey: "CurrentUser")!["name"]else{
            print("name not found")
            return
        }
        //Get data from the firestore database and populate the tableview
        db.collection("Recipe").document(username as! String).collection("My Recipes").addSnapshotListener { (QuerySnapshot, error) in
            if let err = error {
                debugPrint("Error Fetching docs:  \(err)")
            } else {
                self.listRecipes = []
                for document in QuerySnapshot!.documents {
                    //let data = document.data()
                    let recipeImg = document.get("recipeImg") as? String ?? ""
                    let recipeName = document.get("name") as? String ?? "Item"
                    let ckTime = document.get("cookTime") as? String ?? "Item"
                    let servingSize = document.get("servings") as? String ?? "Item"
                    let categoryPicker = document.get("category") as? String ?? "None"
                    let itemCalories = document.get("calories") as? Int ?? 0
                    let itemCarb = document.get("carb") as? Int ?? 0
                    let ingr = document.get("ingredients") as? String ?? "Item"
                    let dir = document.get("directions") as? String ?? "Item"
                    let itemCholesterol = document.get("cholesterol") as? Int ?? 0
                    let itemFat = document.get("fat") as? Int ?? 0
                    let itemFiber = document.get("fiber") as? Int ?? 0
                    let itemProtein = document.get("protein") as? Int ?? 0
                    let itemSodium = document.get("sodium") as? Int ?? 0
                    let itemSugar = document.get("sugar") as? Int ?? 0
                    
                    
                    let newItem = recipeItem(
                                  recipeImg: recipeImg,
                                  name: recipeName,
                                  cookTime: ckTime,
                                  servings: servingSize,
                                  category: categoryPicker,
                                  ingredients: ingr,
                                  directions:dir,
                                  calories: itemCalories,
                                  fat: itemFat,
                                  sodium: itemSodium,
                                  carb: itemCarb,
                                  fiber: itemFiber,
                                  sugar: itemSugar,
                                  protein:itemProtein,
                                  cholesterol: itemCholesterol
                        
                    )
                    self.listRecipes.append(newItem)
                }
                DispatchQueue.main.async {
                    self.recipeTableView.reloadData()
                }
            }
        }
    }
   
    // added code by Daitong Xu, deselectRow,
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    // Segue for the edit view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRecipeSegue" {
            let recipes = sender as! UITableViewCell
            if let indexPath = recipeTableView.indexPath(for: recipes) {
                let vc = segue.destination as! EditRecipeViewController
                vc.getName = listRecipes[indexPath.row].name
                vc.getServings = listRecipes[indexPath.row].servings
                vc.getCookTime = listRecipes[indexPath.row].cookTime
                vc.getCategory = listRecipes[indexPath.row].category
                vc.getIngredients = listRecipes[indexPath.row].ingredients
                vc.getDirections = listRecipes[indexPath.row].directions
                vc.getFat = listRecipes[indexPath.row].fat
                vc.getCalPerServ = listRecipes[indexPath.row].calories
                vc.getCholesterol = listRecipes[indexPath.row].cholesterol
                vc.getCarbs = listRecipes[indexPath.row].carb
                vc.getFiber = listRecipes[indexPath.row].fiber
                vc.getSugar = listRecipes[indexPath.row].sugar
                vc.getSodium = listRecipes[indexPath.row].sodium
                vc.getImage = listRecipes[indexPath.row].recipeImg!

            }
        }
    }
    
    
    // search bar set up function
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        let searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["Name", "Category"]
        searchController.searchBar.delegate = self
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemTeal
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
    }
    
    // filtered results for search query
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            searching = false
            searchingItems = listRecipes
            recipeTableView.reloadData()
        }else{
            searching = true
            filterTableView(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    // search bar cancel action
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        recipeTableView.reloadData()
    }
    
    //search bar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchingItems.count
        }
        return listRecipes.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // add data to table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipes = tableView.dequeueReusableCell(withIdentifier: "recipes", for: indexPath) as! recipeCell
        recipes.recipeCellView.layer.cornerRadius = 8
        if searching{
            let itemsInCell = searchingItems[indexPath.row]
            recipes.recipeName.text = itemsInCell.name
            recipes.recipeCategory.text = "Category: " + String(itemsInCell.category)
            //retrieve image from DB
            if itemsInCell.recipeImg != nil {
                recipes.recipeImage.image = UIImage(named: "no-image-icon")
            }
            else {
                let imageUrl = URL(string: itemsInCell.recipeImg!)!
                let imageData = try! Data(contentsOf: imageUrl)
                recipes.recipeImage.image = UIImage(data: imageData)
            }
            
        }else{
            let itemsInCell = listRecipes[indexPath.row]
            recipes.recipeName.text = itemsInCell.name
            recipes.recipeCategory.text = "Category: " + String(itemsInCell.category)
            //retrieve image from DB
            if itemsInCell.recipeImg == "" {
                recipes.recipeImage.image = UIImage(named: "no-image-icon")
            }
            else {
                let imageUrl = URL(string: itemsInCell.recipeImg!)!
                let imageData = try! Data(contentsOf: imageUrl)
                recipes.recipeImage.image = UIImage(data: imageData)
            }
        
            
            
        }
        return recipes
    }
    
    //filter table based on scope button of search bar
    func filterTableView(index: Int, text: String) {
        switch index {
        case 0:
            searching = true
            searchingItems = listRecipes.filter({ $0.name.lowercased().prefix(text.count) == text.lowercased()})
            recipeTableView.reloadData()
        case 1:
            searching = true
            searchingItems = listRecipes.filter({ $0.category.lowercased().prefix(text.count) == text.lowercased()})
            recipeTableView.reloadData()
        default:
            print("no type")
        }
    }
    
    //delete item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let docName = listRecipes[indexPath.row].name
            guard let username = defaults.dictionary(forKey: "CurrentUser")!["name"]else{
                print("name not found")
                return
            }
            db.collection("Recipe").document(username as! String).collection("My Recipes").document(docName).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed")
                }
                
            }
            print("index path number: ", indexPath.row)
            listRecipes.remove(at: indexPath.row)
            recipeTableView.reloadData()
        }
    }
    
    //unwind seque for add vc and edit vc
    @IBAction func unWindToList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddRecipeViewController, let item = sourceViewController.item{
            let newIndexPath = IndexPath(row: listRecipes.count, section: 0)
            listRecipes.append(item)
            recipeTableView.insertRows(at: [newIndexPath], with: .automatic)
            
        }
    }
}

// Class for the Pantry cell view
class recipeCell: UITableViewCell{

    @IBOutlet weak var recipeCellView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeCategory: UILabel!
    
}

