//
//  PantryListViewController.swift
//  FitHealth+
//
//  Created by Catherine Cheatle on 10/20/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class PantryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var soryByNBtn: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var myList = [PantryItemList]()
    
    var searchingItems = [PantryItemList]()
    var searching = false
    
    var myIndex = 0
    
    private func loadItems(){
        let item1 = PantryItemList(quantity: 5, name: "Apple", exDate: "10/31/20", category: "Fruit", calorie: 95, nutriInfo: "")
        let item2 = PantryItemList(quantity: 3, name: "Banana", exDate: "10/21/20", category: "Fruit", calorie: 105, nutriInfo: "")
        let item3 = PantryItemList(quantity: 6, name: "Kiwi", exDate: "10/31/20", category: "Fruit", calorie: 42, nutriInfo: "")
        let item4 = PantryItemList(quantity: 1, name: "Hot Cheetos", exDate: "12/31/20", category: "Pantry",calorie: 160, nutriInfo: "")
        
        myList += [item1,item2, item3, item4]
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pantry List"
        
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        setUpSearchBar()
        if let savedData = loadSavedItems(){
            myList += savedData
        }else{
            loadItems()
        }
        
    }
    
    //sort by feature
    let sortByOptions = ["A-Z", "Z-A", "Category", "Calories"]
    
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
            cell.itemCalories.text = "Calories: " + String(itemsInCell.calorie)
            cell.itemQuantity.text = "Quantity:" + String(itemsInCell.quantity)
        }else{
            let itemsInCell = myList[indexPath.row]
            cell.itemName.text = itemsInCell.name
            cell.itemCalories.text = "Calories: " + String(itemsInCell.calorie)
            cell.itemQuantity.text = "Quantity:" + String(itemsInCell.quantity)
            
        }
        
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
            searchingItems = myList.filter({ String($0.calorie).lowercased().prefix(text.count) == text.lowercased()})
            tableViewList.reloadData()
        default:
            print("no type")
        }
    }
    //delete item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            myList.remove(at: indexPath.row)
            tableViewList.reloadData()
        }
        
        saveToFileStuff()
    }
    
    //unwind seque
    @IBAction func unWindToList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? PantryItemShowDetailViewController, let item = sourceViewController.item{
            let newIndexPath = IndexPath(row: myList.count, section: 0)
            myList.append(item)
            tableViewList.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        saveToFileStuff()
    }
    
    @IBAction func unWindEditToList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? PantryItemShowDetailViewController, let item = sourceViewController.item{
            let newIndexPath = IndexPath(row: myList.count, section: 0)
            myList.append(item)
            tableViewList.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        saveToFileStuff()
    }
    
    //archive pantry
    func saveToFileStuff(){
        NSKeyedArchiver.archiveRootObject(myList, toFile: PantryItemList.stuffFolder.path)
    }
    
    //unarchive data
    func loadSavedItems() -> [PantryItemList]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: PantryItemList.stuffFolder.path) as? [PantryItemList]
    }
}

class PantryCell: UITableViewCell{
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemCalories: UILabel!
    
    
}
