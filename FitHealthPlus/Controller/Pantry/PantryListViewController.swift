//
//  PantryListViewController.swift
//  FitHealth+
//
//  Created by Catherine Cheatle on 10/20/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase

var myIndex = 0

class PantryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    //Tableview and add bar button
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // View for sort feature
    var containerView = UIView()
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    // Variables
    var myList = [PantryItem]()
    var myIndex = 0
    var choice = 0
    var searchingItems = [PantryItem]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pantry List"
        tableViewList.delegate = self
        tableViewList.dataSource = self
        setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        //code to get data from local UserDefault data, get name when it is loaded
        guard let username = defaults.dictionary(forKey: "CurrentUser")!["name"]else{
            print("name not found")
            return
        }
        
        //Get data from the firestore database and populate the tableview
        db.collection("Pantry").document(username as! String).collection("Pantry List").addSnapshotListener { (QuerySnapshot, error) in
            if let err = error {
                debugPrint("Error Fetching docs:  \(err)")
            } else {
                self.myList = []
                for document in QuerySnapshot!.documents {
                    //let data = document.data()
                    let itemName = document.get("Name") as? String ?? "Item"
                    let itemCalories = document.get("calories") as? Int ?? 0
                    let itemCarb = document.get("carb") as? Int ?? 0
                    let itemCholestrol = document.get("cholestrol") as? Int ?? 0
                    let itemFat = document.get("fat") as? Int ?? 0
                    let itemFiber = document.get("fiber") as? Int ?? 0
                    let itemProtein = document.get("protein") as? Int ?? 0
                    let itemQuantity = document.get("quantity") as? Int ?? 0
                    let itemSodium = document.get("sodium") as? Int ?? 0
                    let itemSugar = document.get("sugar") as? Int ?? 0
                    let itemCategory = document.get("category") as? String ?? "None"
                    let itemExDate = document.get("exDate") as? String ?? "12/31/20"
                    let itemServingSize = document.get("servingSize") as? String ?? "Item"
                    
                    let newItem = PantryItem(name: itemName, quantity: itemQuantity, exDate: itemExDate, category: itemCategory, servingSize: itemServingSize, calories: itemCalories, fat: itemFat, sodium: itemSodium, carb: itemCarb, fiber: itemFiber, sugar: itemSugar, protein: itemProtein, cholestrol: itemCholestrol)
                    
                    self.myList.append(newItem)
                }
                DispatchQueue.main.async {
                    self.tableViewList.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // UIMenu for the Sort menu
        let sortByMenu = UIMenu(title: "Test", options: .displayInline, children: [
            UIAction(title: "A-Z",handler: {[sortByName] _ in sortByName()}),
            UIAction(title: "Z-A",handler: {[sortZtoA] _ in sortZtoA()}),
            UIAction(title: "Category",handler: {[sortByCategory] _ in sortByCategory()}),
            UIAction(title: "Expiration Date",handler: {[sortByExDate] _ in sortByExDate()}),
            UIAction(title: "Calories",handler: {[sortByCalorie] _ in sortByCalorie()})
        ])
        
        let sortButton = UIBarButtonItem(title: "Sort", primaryAction: nil, menu: sortByMenu)
        sortButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [addButton, sortButton]
    }
    
    // Sort By Function for A-Z
    @objc func sortByName(){
        myList = myList.sorted(by: { $0.name < $1.name})
        tableViewList.reloadData()
    }
    
    // Sort By Function for Z-A
    @objc func sortZtoA(){
        myList = myList.sorted(by: { $0.name > $1.name})
        tableViewList.reloadData()
    }
    
    // Sort By Function for Calories
    @objc func sortByCalorie(){
        myList = myList.sorted(by: { $0.calories < $1.calories})
        tableViewList.reloadData()
    }
    
    // Sort By Expiration Date
    @objc func sortByExDate(){
        //Date format for Expiration date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        myList = myList.sorted(by: { dateFormatter.date(from: $0.exDate)! < dateFormatter.date(from: $1.exDate)!})
        tableViewList.reloadData()
    }
    
    // Sort By Category
    @objc func sortByCategory(){
        myList = myList.sorted(by: { $0.category < $1.category})
        tableViewList.reloadData()
    }
    
    // added code by Daitong Xu, deselectRow,
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Segue for the edit view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableViewList.indexPath(for: cell) {
                let vc = segue.destination as! EditPantryItemViewController
                vc.getName = myList[indexPath.row].name
                vc.getCategory = myList[indexPath.row].category
                vc.getQuantity = myList[indexPath.row].quantity
                vc.getCalories = myList[indexPath.row].calories
                vc.getSugar = myList[indexPath.row].sugar
                vc.getProtein = myList[indexPath.row].protein
                vc.getFiber = myList[indexPath.row].fiber
                vc.getCarb = myList[indexPath.row].carb
                vc.getCholesterol = myList[indexPath.row].cholestrol
                vc.getFat = myList[indexPath.row].fat
                vc.getSodium = myList[indexPath.row].sodium
                vc.getExDate = myList[indexPath.row].exDate
                vc.getServingSize = myList[indexPath.row].servingSize
                
            }
        }
    }
    
    // search bar set up function
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        //searchController.navigationItem.hidesSearchBarWhenScrolling = true
        let searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["Name", "Category", "Calories"]
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
            searchingItems = myList
            tableViewList.reloadData()
        }else{
            searching = true
            filterTableView(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    // search bar cancel action
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableViewList.reloadData()
    }
    
    //search bar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchingItems.count
        }
        return myList.count
        
    }
    
    // add data to table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PantryCell
        if searching{
            let itemsInCell = searchingItems[indexPath.row]
            cell.itemName.text = itemsInCell.name
            cell.itemCalories.text = "Calories: " + String(itemsInCell.calories)
            cell.itemQuantity.text = "Quantity:" + String(itemsInCell.quantity)
            cell.itemExDate.text = "Expires: " + String(itemsInCell.exDate)
            
            //category icons
            if itemsInCell.category == "Vegetables" {
                cell.itemImage.image = UIImage(named: "vegetables")!
            }
            if itemsInCell.category == "Fruit" {
                cell.itemImage.image = UIImage(named: "fruits")!
            }
            if itemsInCell.category == "Pantry" {
                cell.itemImage.image = UIImage(named: "pantry")!
            }
            if itemsInCell.category == "Frozen" {
                cell.itemImage.image = UIImage(named: "frozen-yogurt")!
            }
            if itemsInCell.category == "Fridge" {
                cell.itemImage.image = UIImage(named: "fridge")!
            }
            if itemsInCell.category == "Dairy" {
                cell.itemImage.image = UIImage(named: "food")!
            }
            if itemsInCell.category == "Meat" {
                cell.itemImage.image = UIImage(named: "meat")!
            }
            
        }else{
            let itemsInCell = myList[indexPath.row]
            cell.itemName.text = itemsInCell.name
            cell.itemCalories.text = "Calories: " + String(itemsInCell.calories)
            cell.itemQuantity.text = "Quantity:" + String(itemsInCell.quantity)
            cell.itemExDate.text = "Expires: " + String(itemsInCell.exDate)
            
            //category icons
            if itemsInCell.category == "Vegetables" {
                cell.itemImage.image = UIImage(named: "vegetables")!
            }
            if itemsInCell.category == "Fruit" {
                cell.itemImage.image = UIImage(named: "fruits")!
            }
            if itemsInCell.category == "Pantry" {
                cell.itemImage.image = UIImage(named: "pantry")!
            }
            if itemsInCell.category == "Frozen" {
                cell.itemImage.image = UIImage(named: "frozen-yogurt")!
            }
            if itemsInCell.category == "Fridge" {
                cell.itemImage.image = UIImage(named: "fridge")!
            }
            if itemsInCell.category == "Dairy" {
                cell.itemImage.image = UIImage(named: "food")!
            }
            if itemsInCell.category == "Meat" {
                cell.itemImage.image = UIImage(named: "meat")!
            }
            
        }
        
        
        cell.pantryCellView.layer.cornerRadius = cell.pantryCellView.frame.height / 2
        return cell
    }
    
    //filter table based on scope button of search bar
    func filterTableView(index: Int, text: String) {
        switch index {
        case 0:
            searching = true
            searchingItems = myList.filter({ $0.name.lowercased().prefix(text.count) == text.lowercased()})
            tableViewList.reloadData()
        case 1:
            searching = true
            searchingItems = myList.filter({ $0.category.lowercased().prefix(text.count) == text.lowercased()})
            tableViewList.reloadData()
        case 2:
            searching = true
            searchingItems = myList.filter({ String($0.calories).lowercased().prefix(text.count) == text.lowercased()})
            tableViewList.reloadData()
        default:
            print("no type")
        }
    }
    
    //delete item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let docName = myList[indexPath.row].name
            guard let username = defaults.dictionary(forKey: "CurrentUser")!["name"]else{
                print("name not found")
                return
            }
            db.collection("Pantry").document(username as! String).collection("Pantry List").document(docName).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed")
                }
                
            }
            myList.remove(at: indexPath.row)
            tableViewList.reloadData()
        }
    }
    
    //unwind seque for add vc and edit vc
    @IBAction func unWindToList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? PantryItemShowDetailViewController, let item = sourceViewController.item{
            let newIndexPath = IndexPath(row: myList.count, section: 0)
            myList.append(item)
            tableViewList.insertRows(at: [newIndexPath], with: .automatic)
            
        }
    }
}

// Class for the Pantry cell view
class PantryCell: UITableViewCell{
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemCalories: UILabel!
    @IBOutlet weak var itemExDate: UILabel!
    @IBOutlet weak var pantryCellView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    
    func configureCell(pantryItem: PantryItem) {
        itemName.text = pantryItem.name
        itemQuantity.text = String(pantryItem.quantity)
        itemCalories.text = String(pantryItem.calories)
        itemExDate.text = pantryItem.exDate
    }

}


