//
//  AddRecipeViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/22/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDataSource, UITextViewDelegate & UIPickerViewDelegate {
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    //private let storageRef = Storage.storage().reference()
    var imgURL = ""
    var item: recipeItem?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cookTimeField: UITextField!
    @IBOutlet weak var servingsField: UITextField!
    @IBOutlet weak var categoryPicker: UITextField!
    @IBOutlet weak var ingredientsField: UITextView!
    @IBOutlet weak var ingredientsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var directionsField: UITextView!
    @IBOutlet weak var directionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calPerServField: UITextField!
    @IBOutlet weak var fatsField: UITextField!
    @IBOutlet weak var sodiumField: UITextField!
    @IBOutlet weak var carbsField: UITextField!
    @IBOutlet weak var fiberField: UITextField!
    @IBOutlet weak var sugarsField: UITextField!
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var cholesterolField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //cancel adding a new recipe
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveRecipeButton(_ sender: UIButton) {
        saveRecipeItem()
    }
    
    var pickerView = UIPickerView()
    // used for view picker
    let categories = ["Poultry", "Beef", "Pork", "Seafood", "Vegetarian","Dessert"]
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryPicker.text = categories[row]
        categoryPicker.resignFirstResponder()
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
        ingredientsField.delegate = self
        directionsField.delegate = self
        
        //formatting text views' border
        ingredientsField.layer.borderWidth = 0.8
        ingredientsField.layer.borderColor = UIColor.systemGray5.cgColor
        ingredientsField.layer.cornerRadius = 5
        directionsField.layer.borderWidth = 0.8
        directionsField.layer.borderColor = UIColor.systemGray5.cgColor
        directionsField.layer.cornerRadius = 5
        
        saveButton.layer.cornerRadius = 8
        //saveButton.layer.backgroundColor = UIColor.systemTeal.cgColor
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddRecipeViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
 
    }
    
    // selects an image from your photo library
    @IBAction func addImageButton(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    //uploads image to the page
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage]as? UIImage
        else {
            return
        }
        imageUpload.image = image
        let imageID = UUID.init().uuidString
        let storageRef = Storage.storage().reference(withPath: "recipeImages/\(imageID).jpg")
        guard let imageData = imageUpload.image?.jpegData(compressionQuality: 0.75) else {
            return
        }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata:uploadMetadata, completion: { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
        
        
            storageRef.downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                self.imgURL = url.absoluteString
                print("is it working ", self.imgURL)
            })
            
            
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    // To autosize text view to fit content
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == ingredientsField {
            ingredientsViewHeight.constant = ingredientsField.contentSize.height
        }
        else if textView == directionsField {
           directionsViewHeight.constant = directionsField.contentSize.height
      }
    }
    

    private func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == servingsField || textField == cookTimeField{
            servingsField.keyboardType = .numbersAndPunctuation
            cookTimeField.keyboardType = .numbersAndPunctuation
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
            servingsField.becomeFirstResponder()
        }else if textField == servingsField {
            cookTimeField.becomeFirstResponder()
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
        let cholesterol = Int(cholesterolField.text!)
        
        //gets user's name for database
        guard let name = defaults.dictionary(forKey: "CurrentUser")!["name"] else{
            return
        }
        
        let recipeRef = db.collection("Recipe").document(name as! String).collection("My Recipes")
        
        // adds recipe info to the database
        recipeRef.document(recipeName).setData([
            "recipeImg": imgURL,
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
            "cholesterol": cholesterol
        ])
    }
}


