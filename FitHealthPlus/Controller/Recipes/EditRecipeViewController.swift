//
//  EditRecipeViewController.swift
//  FitHealthPlus
//
//  Created by Fayliette Lewis on 11/20/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EditRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDataSource & UIPickerViewDelegate {
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    private let storageRef = Storage.storage().reference()
    var imgURL = ""
    var item: recipeItem?
    

    @IBOutlet weak var servingsField: UITextField!
    @IBOutlet weak var cookTimeField: UITextField!
    @IBOutlet weak var ingredientsField: UITextView!
    @IBOutlet weak var ingredientsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var directionsField: UITextView!
    @IBOutlet weak var directionsViewHeight: NSLayoutConstraint!
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
    @IBOutlet weak var saveButton: UIButton!
    
    var getName = String()
    var getServings = String()
    var getCookTime = String()
    var getIngredients = String()
    var getDirections = String()
    var getCategory = String()
    var getFat = Int()
    var getCalPerServ = Int()
    var getCholesterol = Int()
    var getCarbs = Int()
    var getFiber = Int()
    var getProtein = Int()
    var getSugar = Int()
    var getSodium = Int()
    var getImage = String()
    
    //cancel adding a new recipe
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRecipeButton(_ sender: UIButton) {
        saveRecipeItem()
    }
    
    var pickerView = UIPickerView()
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryPicker.text = categories[row]
        categoryPicker.resignFirstResponder()
    }
    
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var addImgButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.text = getName
        servingsField.text = getServings
        cookTimeField.text = getCookTime
        ingredientsField.text = getIngredients
        categoryPicker.text = getCategory
        directionsField.text = getDirections
        fatsField.text = String(getFat)
        calPerServField.text = String(getCalPerServ)
        cholesterolField.text = String(getCholesterol)
        carbsField.text = String(getCarbs)
        fiberField.text = String(getFiber)
        proteinField.text = String(getProtein)
        sugarsField.text = String(getSugar)
        sodiumField.text = String(getSodium)
        //retrieve image---->
        let url = String(getImage)
        if url == "" {
            imageUpload.image = UIImage(named: "no-image-icon")
        }
        else {
            let imageUrl = URL(string: String(getImage))!
            let imageData = try! Data(contentsOf: imageUrl)
            imageUpload.image = UIImage(data: imageData)
        }
        //^^^^^done retrieving image
        
        addImgButton.layer.cornerRadius = 8
        imagePicker.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryPicker.inputView = pickerView
        categoryPicker.textAlignment = .left
        categoryPicker.placeholder = "Select Category"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditRecipeViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        saveButton.layer.cornerRadius = 8

    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
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
        let cholestrol = Int(cholesterolField.text!)
        
        //gets user's name for database
        guard let name = defaults.dictionary(forKey: "CurrentUser")!["name"] else{
            return
        }
        
        let recipeRef = db.collection("Recipe").document(name as! String).collection("My Recipes").document(recipeName)
        
        // adds recipe info to the database
        recipeRef.updateData([
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
            "cholesterol": cholestrol
        ])
    }
}



