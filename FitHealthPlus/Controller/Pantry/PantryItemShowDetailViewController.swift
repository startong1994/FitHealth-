//
//  PantryItemShowDetailViewController.swift
//  PantryList
//
//  Created by Catherine Cheatle on 10/18/20.
//  Copyright © 2020 Catherine Cheatle. All rights reserved.
//

import UIKit
import Firebase

class PantryItemShowDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate{
    
    //Textbox fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var exDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var servingSizeTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var sodiumTextField: UITextField!
    @IBOutlet weak var carbTextField: UITextField!
    @IBOutlet weak var fiberTextField: UITextField!
    @IBOutlet weak var sugarTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var cholesterolTextField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    //Date Picker and Picker View
    private var datePicker: UIDatePicker?
    
    let itemCategories = ["Fruit", "Vegetables", "Pantry", "Frozen", "Fridge", "Dairy", "Meat"]
    
    var pickerView = UIPickerView()
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        savePantryItem()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let pantryRef = db.collection("Pantry")
        pantryRef.document("test").setData(["test": "this is a test"])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        categoryTextField.textAlignment = .left
        pickerView.backgroundColor = UIColor.systemTeal
        categoryTextField.placeholder = "Select Category"
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        exDateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(PantryItemShowDetailViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PantryItemShowDetailViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        datePicker?.frame = CGRect(x:0, y: 0, width: 280, height: 100)
        datePicker?.backgroundColor = UIColor.systemTeal
        exDateTextField.placeholder = "Select Date"
        
        addBtn.backgroundColor = UIColor.systemTeal
        addBtn.layer.cornerRadius = addBtn.frame.height/2
        
        //Searchbar
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
    var item: PantryItem?
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //get user's name with line 16,
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        exDateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = itemCategories[row]
        categoryTextField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == quantityTextField || textField == caloriesTextField{
            quantityTextField.keyboardType = .numbersAndPunctuation
            caloriesTextField.keyboardType = .numbersAndPunctuation
            fatTextField.keyboardType = .numbersAndPunctuation
            sodiumTextField.keyboardType = .numbersAndPunctuation
            carbTextField.keyboardType = .numbersAndPunctuation
            fiberTextField.keyboardType = .numbersAndPunctuation
            sugarTextField.keyboardType = .numbersAndPunctuation
            proteinTextField.keyboardType = .numbersAndPunctuation
            cholesterolTextField.keyboardType = .numbersAndPunctuation
        }else{
            nameTextField.keyboardType = .default
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            quantityTextField.becomeFirstResponder()
        }else if textField == quantityTextField {
            exDateTextField.becomeFirstResponder()
        }else if textField == exDateTextField{
            caloriesTextField.becomeFirstResponder()
        }else{
            nameTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    //Search Bar API
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        if searchBarText != "" || searchBarText != nil {
            let userQuery = searchBarText.replacingOccurrences(of: " ", with: "%20")
            ingredientAPI.sharedIngredientResult.fetchIngredients(queryString: userQuery, completion: { result in
                let name = result.first?.name!
                let calories = String(result.first?.calories! ?? 0)
                print("Calories" , calories)
                let fat = String(result.first?.fat_total_g! ?? 0)
                let cholestrol = String(result.first?.cholesterol_mg! ?? 0)
                let sodium = String(result.first?.sodium_mg! ?? 0)
                let carbs = String(result.first?.carbohydrates_total_g! ?? 0)
                let fiber = String(result.first?.fiber_g! ?? 0)
                let sugar = String(result.first?.sugar_g! ?? 0)
                let protein = String(result.first?.protein_g! ?? 0)
                let servingSize = String(result.first?.serving_size_g! ?? 0)
                
                self.nameTextField.text = name
                self.caloriesTextField.text = calories
                self.fatTextField.text = fat
                self.cholesterolTextField.text = cholestrol
                self.sodiumTextField.text = sodium
                self.carbTextField.text = carbs
                self.fiberTextField.text = fiber
                self.sugarTextField.text = sugar
                self.proteinTextField.text = protein
                self.servingSizeTextField.text = servingSize
                self.viewDidLoad()
                })
        }
    }
    
    // MARK: - Navigation
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let amount = Int(quantityTextField.text!){
            if let name = nameTextField.text{
                if let expiration = exDateTextField.text{
                    if let category = categoryTextField.text{
                        if let calorie = Int(caloriesTextField.text!){
                            item = PantryItemList(quantity: amount, name: name, exDate: expiration, category: category, calorie: calorie)
                        }
                    }
                }
            }
        }
    }*/
    
    //Save Function
    func savePantryItem(){
        let nameText = nameTextField.text!
        let quantityText = Int(quantityTextField.text!)
        let exDateText = exDateTextField.text!
        let categoryText = categoryTextField.text!
        let servingSizeText = servingSizeTextField.text!
        let calorieText = Int(caloriesTextField.text!)
        let fatText = Int(fatTextField.text!)
        let sodiumText = Int(sodiumTextField.text!)
        let carbText = Int(carbTextField.text!)
        let fiberText = Int(fiberTextField.text!)
        let sugarText = Int(sugarTextField.text!)
        let proteinText = Int(proteinTextField.text!)
        let cholestrolText = Int(cholesterolTextField.text!)
        
        guard let name = defaults.dictionary(forKey: "CurrentUser")!["email"] else{
            return
        }
        
        let pantryRef = db.collection("Pantry").document(name as! String).collection("Pantry List")
        
        pantryRef.document(nameText).setData([
            "Name": nameText,
            "quantity": quantityText,
            "exDate": exDateText,
            "category": categoryText,
            "servingSize": servingSizeText,
            "calories": calorieText,
            "fat": fatText,
            "sodium": sodiumText,
            "carb": carbText,
            "fiber": fiberText,
            "sugar": sugarText,
            "protein": proteinText,
            "cholestrol": cholestrolText
        ])
        
    }
}
