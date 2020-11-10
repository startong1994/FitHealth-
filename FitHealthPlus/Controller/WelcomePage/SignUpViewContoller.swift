//
//  SignUpViewContoller.swift
//  FitHealth+
//
//  Created by xu daitong on 10/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewContoller: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var UserName: UITextField!
    
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        profileImage.image = UIImage(named: "person")
    }
    
    

    @IBAction func registerPressed(_ sender: UIButton) {
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        let userRef = db.collection("users")
        
        
        if let email = emailTextField.text, let password = passwordTextField.text, let name = UserName.text {
            
            if email.hasSuffix("uncc.edu"){
                //create User Auth
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error{
                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    self.performSegue(withIdentifier: "registerToSignIn", sender: self)
                }
            }
                
                //write users information to database,
                userRef.document(email).setData([
                    "name": name,
                    "email": email,
                    "profileImage": "person"

                ])
                
            
        }
            else{
                
                let alert = UIAlertController(title: "Error", message: "Please Enter UNCC School Email", preferredStyle: .alert)
                
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                
                print("not school email address")
            }
        
        
        }
        
        
        
    }
    
}
