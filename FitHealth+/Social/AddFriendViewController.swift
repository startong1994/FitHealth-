//
//  AddFriendViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/18/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit

class AddFriendController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let friendData = FriendsData()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Add Friends"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Friend", message: "", preferredStyle: .alert)
        let added = UIAlertController(title: "", message: "Request sent!", preferredStyle: .alert)
        
        var emailAddress = UITextField()
        
        
        //ok botton for conformation alert pop up
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        
        
        //confirm button function
        let addFriend = UIAlertAction(title: "Confirm", style: .default) { (addFriend) in
            if let address = emailAddress.text{
                print(address + " added")
                
                added.addAction(ok)
                self.present(added, animated: true, completion: nil)

            }
        }
        alert.addAction(addFriend)
        //cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Email Address"
            emailAddress = textField
        }
        alert.addAction(cancel)
        
        alert.preferredAction = addFriend
        present(alert,animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendData.newFriendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileImage = friendData.getNewFriendName(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "newFriendCell", for: indexPath)
        cell.textLabel?.text = friendData.getNewFriendName(indexPath.row)
        cell.imageView?.image = UIImage(named: profileImage)
        
        return cell
    }
    
    
}
