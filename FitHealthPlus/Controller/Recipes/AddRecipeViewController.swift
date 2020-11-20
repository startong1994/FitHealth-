//
//  AddRecipeViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/22/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDataSource & UIPickerViewDelegate {
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    

    @IBOutlet weak var servingsField: UITextField!
    @IBOutlet weak var ingredientsField: UITextField!
    @IBOutlet weak var cookTimeField: UITextField!
    @IBOutlet weak var directionsField: UITextField!
    @IBOutlet weak var fatsField: UITextField!
    @IBOutlet weak var calPerServField: UITextField!
    @IBOutlet weak var cholesterolField: UITextField!
    @IBOutlet weak var carbsField: UITextField!
    @IBOutlet weak var fiberField: UITextField!
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var sugarsField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var sodiumField: UITextField!
    @IBOutlet weak var categoryPicker: UITextField!
    
    //cancel adding a new recipe
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    //saves new recipe to database
    
    @IBAction func addRecipeButton(_ sender: Any) {
        let recipeRef = db.collection("Recipe")
        recipeRef.document("test").setData(["test":"this is a test"])
    }
    
    @IBAction func saveRecipeButton(_ sender: UIButton) {
        saveRecipeItem()
    }
    
    private var pickerView = UIPickerView()
    // used for view picker
    let categories = ["Poultry", "Beef", "Pork", "Seafood", "Vegetarian"]
    //view picker number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // uses the number of caleris to add that many rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    // used to assign the category chosen selected
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var addImgButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addImgButton.layer.cornerRadius = 8
        imagePicker.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryPicker.inputView = pickerView
        categoryPicker.textAlignment = .left
        categoryPicker.placeholder = "Select Category"

    }
    
    // selects an image from your photo library
    @IBAction func addImageButton(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    //uploads image to the page
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage]as? UIImage {
                    imageUpload.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    var item: recipeItem?
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == nameField || textField == calPerServField{
            categoryPicker.keyboardType = .numbersAndPunctuation
            servingsField.keyboardType = .numbersAndPunctuation
            cookTimeField.keyboardType = .numbersAndPunctuation
            ingredientsField.keyboardType = .numbersAndPunctuation
            directionsField.keyboardType = .numbersAndPunctuation
            fatsField.keyboardType = .numbersAndPunctuation
            sodiumField.keyboardType = .numbersAndPunctuation
            carbsField.keyboardType = .numbersAndPunctuation
            fiberField.keyboardType = .numbersAndPunctuation
            sugarsField.keyboardType = .numbersAndPunctuation
            proteinField.keyboardType = .numbersAndPunctuation
            cholesterolField.keyboardType = .numbersAndPunctuation
        }else{
            nameField.keyboardType = .default
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            calPerServField.becomeFirstResponder()
        }else{
            nameField.becomeFirstResponder()
        }
        return true
    }
    
    func saveRecipeItem(){
        let recipeName = nameField.text!
        let category = categoryPicker.text!
        let servings = servingsField.text!
        let cookTime = cookTimeField.text!
        let ingredients = ingredientsField.text!
        let directions = directionsField.text!
        let calories = Int(calPerServField.text!)
        let fat = Int(fatsField.text!)
        let sodium = Int(sodiumField.text!)
        let carbs = Int(carbsField.text!)
        let fiber = Int(fiberField.text!)
        let sugar = Int(sugarsField.text!)
        let protein = Int(proteinField.text!)
        let cholestrol = Int(cholesterolField.text!)
        
        //gets user's name for database
        guard let name = defaults.dictionary(forKey: "CurrentUser")!["name"] else{
            return
        }
        
        let recipeRef = db.collection("Recipe").document(name as! String).collection("My Recipes")
        
        // adds recipe info to the database
        recipeRef.document(recipeName).setData([
            "name": recipeName,
            "category": category,
            "servings": servings,
            "cookTime": cookTime,
            "ingredients": ingredients,
            "directions": directions,
            "calories": calories,
            "fat": fat,
            "sodium": sodium,
            "carb": carbs,
            "fiber": fiber,
            "sugar": sugar,
            "protein": protein,
            "cholesterol": cholestrol
        ])
    }
}


