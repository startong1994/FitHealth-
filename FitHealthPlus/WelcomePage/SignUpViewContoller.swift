//
//  SignUpViewContoller.swift
//  FitHealth+
//
//  Created by xu daitong on 10/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewContoller: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    

    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            if email.hasSuffix("uncc.edu"){

            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error{
                    print(e)
                }
                else{
                    self.performSegue(withIdentifier: "registerToSignIn", sender: self)
                }
            }
            
        }
            else{
                
                let alert = UIAlertController(title: "Error", message: "Please Enter UNCC School Email", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                
                print("not school address")
            }
        
        
        }
        
        
        
    }
    
}
