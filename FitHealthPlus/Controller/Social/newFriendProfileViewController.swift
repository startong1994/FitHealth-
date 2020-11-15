//
//  NewFriendProfileViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/19/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import CoreData

class NewFriendProfileViewController: UIViewController {
    
    var pendingFriend: PendingLists?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadPendingProfile()
       
        
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        print("Accpeted")
    }
    
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        print("Rejected")
    }
    
    func loadPendingProfile(){
        if let image = pendingFriend?.profileImage, let name = pendingFriend?.name,
           let email = pendingFriend?.email{
            profileName.text = name
            print(name)
            profileEmail.text = email
            print(email)
            profileImage.image  = UIImage(named: image)
            print(image)
            
        }
        
        
    }
    


}
