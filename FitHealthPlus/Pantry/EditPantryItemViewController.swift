//
//  EditPantryItemViewController.swift
//  FitHealth+
//
//  Created by Catherine Cheatle on 10/21/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class EditPantryItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var exDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var nutritionalTextField: UITextField!
    
    let itemCategories = ["Fruit", "Vegetables", "Pantry", "Frozen", "Fridge", "Dairy", "Meat"]
    
    var pickerView = UIPickerView()
    var item: PantryItemList?
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        categoryTextField.textAlignment = .center
        
        //nameTextField.delegate = self
        if let item = item{
            nameTextField.text = item.name
            quantityTextField.text = String(item.quantity)
            exDateTextField.text = item.exDate
            categoryTextField.text = item.category
            calorieTextField.text = String(item.calorie)
            nutritionalTextField.text = item.nutriInfo
        }
        
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
        if textField == quantityTextField || textField == calorieTextField{
            quantityTextField.keyboardType = .numbersAndPunctuation
            calorieTextField.keyboardType = .numbersAndPunctuation
        }else{
            nameTextField.keyboardType = .default
            exDateTextField.keyboardType = .default
            nutritionalTextField.keyboardType = .default
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            quantityTextField.becomeFirstResponder()
        }else if textField == quantityTextField {
            exDateTextField.becomeFirstResponder()
        }else if textField == exDateTextField{
            calorieTextField.becomeFirstResponder()
        }else if textField == calorieTextField{
            nutritionalTextField.becomeFirstResponder()
        }else{
            nameTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let amount = Int(quantityTextField.text!){
            if let name = nameTextField.text{
                if let expiration = exDateTextField.text{
                    if let category = categoryTextField.text{
                        if let calorie = Int(calorieTextField.text!){
                            if let nutri = nutritionalTextField.text{
                                item = PantryItemList(quantity: amount, name: name, exDate: expiration, category: category, calorie: calorie, nutriInfo: nutri)
                            }
                        }
                    }
                }
            }
        }
    }
}
