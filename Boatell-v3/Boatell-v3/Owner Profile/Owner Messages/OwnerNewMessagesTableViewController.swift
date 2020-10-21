//
//  OwnerNewMessagesTableViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class OwnerNewMessagesTableViewController: UITableViewController {

        //MARK: - Properties
        var messagesController: OwnerMessagesTableViewController?
        var users = [Users]()
        
    
        //MARK: - View Life Cycles
        override func viewDidLoad() {
            super.viewDidLoad()

            fetchUsers()
            
        }
        

    //MARK: - Fetch User from Database
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Users()
                user.id = snapshot.key
                
                //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                // print(user.name!, user.email!)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }
            
            
        }, withCancel: nil)
    }

        // MARK: - Table view data source
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return users.count
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)

            let user = users[indexPath.row]
            
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.email
           
            cell.imageView?.image = UIImage(named: "User")
        
            
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)! / 2
            
            
            
            if let profileImageUrl = user.profileImageURL {
                
                cell.imageView?.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
               
                
            }

            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)! / 2
            
            return cell
        }
        
 

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OwnerMessageSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? OwnerChatLogsViewController else{return}
            detailVC.user = users[indexPath.row]
            
        }
    }

    }
