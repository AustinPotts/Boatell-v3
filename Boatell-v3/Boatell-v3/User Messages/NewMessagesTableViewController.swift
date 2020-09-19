//
//  NewMessagesTableViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class NewMessagesTableViewController: UITableViewController {

   
        var messagesController: MessagesTableViewController?
        
        var users = [User]()
    
        var owners = [Owner]()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            fetchUsers()
            fetchOwner()
            
            
        }
        
    
       //MARK: Fetch Owner : User should only be able to message their mechanic
    func fetchOwner(){
           

          Database.database().reference().child("owner").child("owner").observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 
                       
                       if let dictionary = snapshot.value as? [String: AnyObject] {
                        let owner = Owner()
                        owner.id = snapshot.key
                        
                        //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                        owner.setValuesForKeys(dictionary)
                        self.owners.append(owner)
                        // print(user.name!, user.email!)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                       }
                       print(snapshot)
                   }, withCancel: nil)
         }

        
        func fetchUsers() {
            Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User()
                    user.id = snapshot.key
                    
                    //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                    user.setValuesForKeys(dictionary)
                    self.users.append(user)
                   // print(user.name!, user.email!)
                    
                    DispatchQueue.main.async {
                         self.tableView.reloadData()
                    }
                   
                    
                }
                
                
    //            print(snapshot)
                
            }, withCancel: nil)
        }

        // MARK: - Table view data source

    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 5
    //    }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return owners.count
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)

            let owner = owners[indexPath.row]
            
            cell.textLabel?.text = owner.name
            cell.detailTextLabel?.text = owner.email
           
            cell.imageView?.image = UIImage(named: "User")
        
            
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.layer.cornerRadius = 50.0
            
            
            
            if let profileImageUrl = owner.profileImageURL {
                
                cell.imageView?.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                
    //            let url = URL(string: profileImageUrl)
    //
    //            URLSession.shared.dataTask(with: url!) { (data, response, error) in
    //
    //                if let error = error {
    //                    print("Error getting image: \(error)")
    //                    return
    //                }
    //
    //                DispatchQueue.main.async {
    //                     cell.imageView?.image = UIImage(data: data!)
    //                }
    //
    //
    //            }.resume()
                
            }

            return cell
        }
        
//        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//            let user = self.users[indexPath.row]
//
//            performSegue(withIdentifier: "MessageSegue", sender: nil)
//        }


        /*
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        */

        /*
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        */

        /*
        // Override to support rearranging the table view.
        override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        }
        */

        /*
        // Override to support conditional rearranging of the table view.
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the item to be re-orderable.
            return true
        }
        */

        
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "MessageSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? ChatLogsViewController else{return}
                detailVC.owner = owners[indexPath.row]
                
            }
        }
        

    }

