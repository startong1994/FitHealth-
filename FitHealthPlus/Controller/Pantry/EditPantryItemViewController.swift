//
//  EditPantryItemViewController.swift
//  FitHealth+
//
//  Created by Catherine Cheatle on 10/21/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase
class EditPantryItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

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
    private var datePicker: UIDatePicker?

    // variables to get information from Pantry List View Table
    var getName = String()
    var getCategory = String()
    var getQuantity = Int()
    var getExDate = String()
    var getServingSize = String()
    var getCalories = Int()
    var getFat = Int()
    var getSodium = Int()
    var getCarb = Int()
    var getFiber = Int()
    var getSugar = Int()
    var getProtein = Int()
    var getCholesterol = Int()
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    // List of Categories for pickerview
    let itemCategories = ["Fruit", "Vegetables", "Pantry", "Frozen", "Fridge", "Dairy", "Meat"]
    
    var pickerView = UIPickerView()
    
    // Pantry item
    var item: PantryItem?
    
    // Nav Bar
    @IBOutlet weak var editItemNavBar: UINavigationBar!
    
    // Cancel Button, to go back to prev screen
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Save button
    @IBAction func addBtn(_ sender: UIButton) {
        savePantryItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Text Fields to item's attributes
        nameTextField.text = getName
        quantityTextField.text = String(getQuantity)
        exDateTextField.text = getExDate
        categoryTextField.text = getCategory
        servingSizeTextField.text = getServingSize
        caloriesTextField.text = String(getCalories)
        fatTextField.text = String(getFat)
        sodiumTextField.text = String(getSodium)
        carbTextField.text = String(getCarb)
        fiberTextField.text = String(getFiber)
        sugarTextField.text = String(getSugar)
        proteinTextField.text = String(getProtein)
        cholesterolTextField.text = String(getCholesterol)
        
        // Pickerview display
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        categoryTextField.textAlignment = .left
        pickerView.backgroundColor = UIColor.systemTeal
        
        // Date picker for exDate
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        exDateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(EditPantryItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditPantryItemViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        datePicker?.frame = CGRect(x:0, y: 0, width: 280, height: 100)
        datePicker?.backgroundColor = UIColor.systemTeal
        exDateTextField.placeholder = "Select Date"
        
        // UIDesign for save button and nav bar
        addBtn.backgroundColor = UIColor.systemTeal
        addBtn.layer.cornerRadius = addBtn.frame.height/2
        editItemNavBar.barTintColor = UIColor.systemTeal
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
    
    /*// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let amount = Int(quantityTextField.text!){
            if let name = nameTextField.text{
                if let expiration = exDateTextField.text{
                    if let category = categoryTextField.text{
                        if let calorie = Int(calorieTextField.text!){
                                item = PantryItemList(quantity: amount, name: name, exDate: expiration, category: category, calorie: calorie)
                        }
                    }
                }
            }
        }
    }*/
    // Save function to save to database
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
        
        let pantryRef = db.collection("Pantry").document(name as! String).collection("Pantry List").document(nameText)
        
        pantryRef.updateData([
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
