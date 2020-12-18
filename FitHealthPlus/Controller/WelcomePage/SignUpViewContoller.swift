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
    @IBOutlet weak var UserName: UITextField!
    
    let db = Firestore.firestore()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //profileImage.image = UIImage(named: "person")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UINavigationBar.appearance().backgroundColor = UIColor.systemTeal
    }
    
    

    @IBAction func registerPressed(_ sender: UIButton) {
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        
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
                    
                    //write users information to database,
                    UsersData().addNewUser(email: email, name: name, profileImage: "person")
                    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                        if let e = error{
                            print(e.localizedDescription)
                        }
                        else{
                            
                            UsersData().storeCurrentUserData()
                            
                            FriendNetwork().run(after: 3) {
                                self.performSegue(withIdentifier: "registerToMain", sender: self)
                            }
                        }
                    }
                    
                }
            }
            
        }
            else{
                
                let alert = UIAlertController(title: "Error", message: "Please Enter UNCC School Email", preferredStyle: .alert)
                
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                
                print("not school email address")
            }
        
        
        }
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
