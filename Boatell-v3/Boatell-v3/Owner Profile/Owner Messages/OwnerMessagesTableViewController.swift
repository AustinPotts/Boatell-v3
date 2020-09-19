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

   override func viewDidLoad() {
               super.viewDidLoad()
               
             checkIfUserLoggedIn()
           
               let newMessageController = OwnerNewMessagesTableViewController()
                      newMessageController.messagesController = self
             
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

           override func numberOfSections(in tableView: UITableView) -> Int {
               // #warning Incomplete implementation, return the number of sections
               return 0
           }

           override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               // #warning Incomplete implementation, return the number of rows
               return 0
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
