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
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    
    var myList = [PantryItem]()
    //var pantryItemsCollectionRef: CollectionReference!
    var myIndex = 0
    var searchingItems = [PantryItem]()
    var searching = false
    
    private func loadItems(){
        let item1 = PantryItem(name: "Hot Cheetohs", quantity: 1, exDate: "11/20/20", category: "Pantry", servingSize: "1", calories: 360, fat: 0, sodium: 0, carb: 0, fiber: 0, sugar: 0, protein: 0, cholestrol: 0)
        
        myList += [item1]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pantry List"
        tableViewList.delegate = self
        tableViewList.dataSource = self
        setUpSearchBar()
        
        //loadItems()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //code to get data from local UserDefault data, get name when it is loaded
        guard let username = defaults.dictionary(forKey: "CurrentUser")!["name"]else{
            print("name not found")
            return
        }
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
        let sortButton = UIBarButtonItem(title: "Sort", primaryAction: nil, menu: sortMenu)
        sortButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [sortButton, addButton]
    }
    
    //sort by feature
    /*let sortByOptions = ["A-Z", "Z-A", "Category", "Calories"]
    
    @IBAction func sortByPressed(_ sender: Any) {
        if pickerView.isHidden{
            pickerView.isHidden = false
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortByOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortByOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if sortByOptions[row] == "A-Z"{
            myList = myList.sorted(by: { $0.name < $1.name})
            
        } else if sortByOptions[row] == "Z-A" {
            myList = myList.sorted(by: { $0.name > $1.name})
        }else if sortByOptions[row] == "Category" {
            myList = myList.sorted(by: { $0.category < $1.category})
        }else {
            myList = myList.sorted(by: { $0.calorie < $1.calorie})
        }
        
        pickerView.isHidden = true
        tableViewList.reloadData()
    }*/
    
    // Sort By Menu
    let sortMenu = UIMenu(title: "", children: [
        UIAction(title: "A-Z", handler: { (action) in
            print("A-Z Pressed")
        }),UIAction(title: "Z-A") { action in
            
        },UIAction(title: "Calories") { action in
            
        },UIAction(title: "Expiration Date") { action in
            
        },
    ])
    
    func sortByName(){
        myList = myList.sorted(by: { $0.name < $1.name})
        tableViewList.reloadData()
    }
    
    // added code by Daitong Xu, deselectRow,
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
    
    
    //search bar
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PantryCell
        if searching{
            let itemsInCell = searchingItems[indexPath.row]
            cell.itemName.text = itemsInCell.name
            cell.itemCalories.text = "Calories: " + String(itemsInCell.calories)
            cell.itemQuantity.text = "Quantity:" + String(itemsInCell.quantity)
            cell.itemExDate.text = "Expires: " + String(itemsInCell.exDate)
        }else{
            let itemsInCell = myList[indexPath.row]
            cell.itemName.text = itemsInCell.name
            cell.itemCalories.text = "Calories: " + String(itemsInCell.calories)
            cell.itemQuantity.text = "Quantity:" + String(itemsInCell.quantity)
            cell.itemExDate.text = "Expires: " + String(itemsInCell.exDate)
            
        }
        cell.pantryCellView.layer.cornerRadius = cell.pantryCellView.frame.height / 2
        return cell
    }
    
    //filter table based on scope button
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
        
        //saveToFileStuff()
    }
    
    //unwind seque
    @IBAction func unWindToList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? PantryItemShowDetailViewController, let item = sourceViewController.item{
            let newIndexPath = IndexPath(row: myList.count, section: 0)
            myList.append(item)
            tableViewList.insertRows(at: [newIndexPath], with: .automatic)
            
        }
    }
    
    /*//archive pantry
    func saveToFileStuff(){
        NSKeyedArchiver.archiveRootObject(myList, toFile: PantryItem.stuffFolder.path)
    }
    
    //unarchive data
    func loadSavedItems() -> [PantryItem]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: PantryItemList.stuffFolder.path) as? [PantryItemList]
    }*/
}

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
