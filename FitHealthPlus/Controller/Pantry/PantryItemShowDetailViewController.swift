//
//  PantryItemShowDetailViewController.swift
//  PantryList
//
//  Created by Catherine Cheatle on 10/18/20.
//  Copyright © 2020 Catherine Cheatle. All rights reserved.
//

import UIKit

class PantryItemShowDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    
    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var exDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var nutriInfoTextField: UITextField!
    private var datePicker: UIDatePicker?
    
    let itemCategories = ["Fruit", "Vegetables", "Pantry", "Frozen", "Fridge", "Dairy", "Meat"]
    
    var pickerView = UIPickerView()
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        nutriInfoTextField.placeholder = "test"
        // Do any additional setup after loading the view.
    }
    var item: PantryItemList?
    
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
        if textField == quantityTextField || textField == calorieTextField{
            quantityTextField.keyboardType = .numbersAndPunctuation
            calorieTextField.keyboardType = .numbersAndPunctuation
        }else{
            nameTextField.keyboardType = .default
            exDateTextField.keyboardType = .default
            nutriInfoTextField.keyboardType = .default
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
            nutriInfoTextField.becomeFirstResponder()
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
                            if let nutri = nutriInfoTextField.text{
                                item = PantryItemList(quantity: amount, name: name, exDate: expiration, category: category, calorie: calorie, nutriInfo: nutri)
                            }
                        }
                    }
                }
            }
        }
    }
}
