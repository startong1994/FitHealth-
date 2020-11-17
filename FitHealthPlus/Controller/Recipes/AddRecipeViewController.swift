//
//  AddRecipeViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/22/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addImageButton.layer.cornerRadius = 8
        imagePicker.delegate = self
        
        
    }

    @IBAction func cancelAddRecipe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    var imagePicker = UIImagePickerController()
    
    @IBAction func addImage(_ sender: Any) {
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


