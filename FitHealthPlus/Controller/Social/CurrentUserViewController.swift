//
//  CurrentUserViewController.swift
//  FitHealthPlus
//
//  Created by xu daitong on 11/17/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//
import UIKit
import FirebaseAuth


class CurrentUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let selection = ["Change Profile Image", "Change Name", "Change Password", "Logout"]

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Profile"
        self.tabBarController?.tabBar.isHidden = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView()
        
        
        
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        
        
        
        
        
//        name.text = UsersData().getCurrentUser()
//        email.text = UsersData().getCurrentEmail()
//        profileImage.image = UIImage(named: UsersData().getCurrentProfileImage())
        //self.tableView.dataSource = self
        
        
        //***for action when tab on image
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CurrentUserViewController.imagePressed(gesture:)))
//
//        profileImage.addGestureRecognizer(tapGesture)
//        profileImage.isUserInteractionEnabled = true
        
        
    }
    
    //logout
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        print("logout pressed")
        do{
            try Auth.auth().signOut()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let welcomePageVC = storyBoard.instantiateViewController(withIdentifier: "WelcomePage") as! WelcomePageViewController
            
            
            self.navigationController?.pushViewController(welcomePageVC, animated: false)
        }catch let error as NSError{
            print("signing out error \(error)")
        }
    }
    
    //***for action when tab on image********
    
    
//    @objc func imagePressed(gesture: UIGestureRecognizer){
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            print("button pressed")
//
//            imagePicker.delegate = self
//            imagePicker.sourceType = .savedPhotosAlbum
//            imagePicker.allowsEditing = true
//
//            present(imagePicker, animated: true, completion: nil)
//        }
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//       guard let image = info[.originalImage] as? UIImage else{
//            print("error getting image")
//            return
//        }
//
//        profileImage.image = image
//        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
//
//        print("eeror")
//    }
    
}



extension CurrentUserViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
            
            tableView.rowHeight = 230
            
            cell.email.text = UsersData().getCurrentEmail()
            cell.name.text = UsersData().getCurrentUser()
            cell.profileImage.image = UIImage(named: UsersData().getCurrentProfileImage())
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "selections", for: indexPath)
            tableView.rowHeight = 50
            
            cell.textLabel?.text = selection[indexPath.row - 1]
            
            
            return cell
            
                
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

