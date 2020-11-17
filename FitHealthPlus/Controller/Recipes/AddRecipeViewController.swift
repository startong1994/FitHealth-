//
//  AddRecipeViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/22/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDataSource & UIPickerViewDelegate {
    
    let categories = ["Poultry", "Beef", "Pork", "Seafood", "Vegetarian"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
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
    
    @IBAction func cancelAddRecipe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        }
    
    @IBAction func addImageButton(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage]as? UIImage {
                    imageUpload.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


