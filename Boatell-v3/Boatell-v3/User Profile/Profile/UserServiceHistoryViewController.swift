//
//  UserServiceHistoryViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class UserServiceHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    var users = [User]()
    var confirmed = [Confirm]()
    
    
    @IBOutlet var serviceHistoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceTableViewCell else {return UITableViewCell()}
        
        cell.confirmed = confirmed[indexPath.row]
        
        return cell
        
     }
    
    //MARK: - Fetch User From Database
          func fetchUsers() {
            let uid = Auth.auth().currentUser?.uid
            var confimred = [Confirm]()
            
            Database.database().reference().child("users").child(uid!).child("confirmed").observe(.childAdded, with: { (snapshot) in
                  
                  if let dictionary = snapshot.value as? [String: AnyObject] {
                      let user = User()
                      
                      //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                      user.setValuesForKeys(dictionary)
                      
                      self.users.append(user)
                          
                      DispatchQueue.main.async {
                           self.serviceHistoryTableView.reloadData()
                      }
                  }
                  print(snapshot)
              }, withCancel: nil)
          }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
