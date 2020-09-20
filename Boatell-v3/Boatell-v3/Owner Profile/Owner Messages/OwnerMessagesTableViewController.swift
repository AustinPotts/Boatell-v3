//
//  OwnerMessagesTableViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class OwnerMessagesTableViewController: UITableViewController {
    
    var messages = [Message]()

   override func viewDidLoad() {
               super.viewDidLoad()
               
             checkIfUserLoggedIn()
           
               let newMessageController = OwnerNewMessagesTableViewController()
                      newMessageController.messagesController = self
    
       tableView.delegate = self
       tableView.dataSource = self
       observeMessages()
             
           }
    
    func observeMessages() {
           let ref = Database.database().reference().child("messages")
           ref.observe(.childAdded, with: { (snapshot) in
               
               
               if let dictionary = snapshot.value as? [String:AnyObject] {
                   let message = Message()
                   message.setValuesForKeys(dictionary)
                   self.messages.append(message)
                   print("Messages Snapshot: \(snapshot)")
                   
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
                   
               }
               
           
               
           }, withCancel: nil)
       }
           
           
           
           func checkIfUserLoggedIn(){
               //MARK: - Check if user is singed in FIXME
               if Auth.auth().currentUser?.uid == nil {
                   self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
               } else {
                   let uid = Auth.auth().currentUser?.uid
                   Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                       
                       if let dictionary = snapshot.value as? [String:AnyObject] {
                           self.navigationItem.title = dictionary["name"] as? String
                       }
                       
                       
                       
                       //print(snapshot)
                   }, withCancel: nil)
               }
           }

           // MARK: - Table view data source

         

           override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               // #warning Incomplete implementation, return the number of rows
            return messages.count
           }
    
          override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
              
              let message = messages[indexPath.row]
               if let toID = message.toID {
                                let ref = Database.database().reference().child("users").child(toID)
                         ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                                   if let dictionary = snapshot.value as? [String: AnyObject] {

                                     cell.textLabel?.text = dictionary["name"] as? String
                                     
                                       }
                         }, withCancel: nil)
                         
                            }
            cell.detailTextLabel?.text = message.text
                  
                  
              
              return cell
              
          }
           
           
           @IBAction func logoutTapped(_ sender: Any) {
                   do {
                         try Auth.auth().signOut()
                     } catch let logoutError{
                         print(logoutError)
                     }
                     
                   //  let loginController = LoginViewController()


           self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
             
           
               
           }
           
           @IBAction func chatTapped(_ sender: Any) {
               
               //showChatController()
               
           }
           
           func showChatControllerForUser(user: User) {

               let chatLogController = ChatLogsViewController()
              // chatLogController.user = user
           
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "OwnerChatLogController") as! OwnerChatLogsViewController
            self.navigationController?.pushViewController(resultViewController, animated: true)

           }

          
           
           // MARK: - Navigation

           // In a storyboard-based application, you will often want to do a little preparation before navigation
           override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               // Get the new view controller using segue.destination.
               if segue.identifier == "OwnerNewMessageSegue" {
                   if let newMessVC = segue.destination as? OwnerNewMessagesTableViewController {
                    newMessVC.messagesController = self
                   }
              }
               // Pass the selected object to the new view controller.
           }
           


    }
