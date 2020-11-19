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
    @IBOutlet weak var sodiumField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBAction func saveRecipeButton(_ sender: UIButton) {
    }
    
    
    
    
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
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addImgButton.layer.cornerRadius = 8
        imagePicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
    }
    
    // Cancel adding a recipe
    @IBAction func cancelAddRecipe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
}


