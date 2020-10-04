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
    var messagesDictionary = [String: Message]()
    var users = [Users]()

   override func viewDidLoad() {
               super.viewDidLoad()
               
             checkIfUserLoggedIn()
           
               let newMessageController = OwnerNewMessagesTableViewController()
                      newMessageController.messagesController = self
    
       tableView.delegate = self
       tableView.dataSource = self
   // observeMessages()
    observeUserMessages()
    fetchUsers()
             
           }
    
       func fetchUsers() {
            Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = Users()
                    
                    //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                    user.setValuesForKeys(dictionary)
                        
                    self.users.append(user)
                        
                    
    
                    DispatchQueue.main.async {
                         self.tableView.reloadData()
                    }
                }
                print(snapshot)
            }, withCancel: nil)
        }
    
    func observeUserMessages(){
          
        guard let uuid = Auth.auth().currentUser?.uid else {return}
        
                    
            let ref = Database.database().reference().child("user-messages").child(uuid)
                ref.observe(.childAdded, with: { (snapshot) in
                    print("Snapshot 1: \(snapshot)")
                    let messageID = snapshot.key
                    let messageRef = Database.database().reference().child("messages").child(messageID)
                    
                    messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        print("Snapshot 2: \(snapshot)")
                        if let dictionary = snapshot.value as? [String:AnyObject] {
                            let message = Message()
                            message.setValuesForKeys(dictionary)
                            // self.messages.append(message)
                            print("Messages Snapshot: \(snapshot)")
                            
                            if let chatPartnerID = message.chatPartnerID() {
                                self.messagesDictionary[chatPartnerID] = message
                                self.messages = Array(self.messagesDictionary.values)
                                //sort
//                                self.messages.sort { (m1, m2) -> Bool in
//                                    let m1Convert = Int(m1.timeStamp!)
//                                    let m2Convert = Int(m2.timeStamp!)
//                                    return m1Convert! > m2Convert!
//                                }
                            }
                            
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                    }, withCancel: nil)
                    
                    
                }, withCancel: nil)
        
          
    
          
      }
    
    
    func observeMessages() {
           let ref = Database.database().reference().child("messages")
           ref.observe(.childAdded, with: { (snapshot) in
               
               
               if let dictionary = snapshot.value as? [String:AnyObject] {
                   let message = Message()
                   message.setValuesForKeys(dictionary)
                  // self.messages.append(message)
                   print("Messages Snapshot: \(snapshot)")
                if let toID = message.toID {
                    self.messagesDictionary[toID] = message
                    self.messages = Array(self.messagesDictionary.values)
                    //sort
                    //                    self.messages.sort { (m1, m2) -> Bool in
                    //                        return m1.timeStamp > m2.timeStamp
                    //                    }
                }
                   
                   
               }
               
           
               
           }, withCancel: nil)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

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
            
            var timeLabel: UILabel = {
                     let label = UILabel()
                     label.text = "HH:MM:SS"
                     label.font = UIFont.systemFont(ofSize: 13)
                     label.textColor = UIColor.darkGray
                     
                     label.translatesAutoresizingMaskIntoConstraints = false
                     return label
                 }()
              
              let message = messages[indexPath.row]
            
             
                          //mesage.chatPartnerID
            if let toID = message.chatPartnerID() {
                let ref = Database.database().reference().child("users").child(toID)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                   // print("SNAP: \(snapshot.value)")
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                        cell.textLabel?.text = dictionary["name"] as? String
                        if let profileImageUrl = dictionary["profileImageURL"] as? String {
                            cell.imageView?.image = UIImage(named: "User")
                            cell.imageView?.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)! / 2
                            cell.imageView?.layer.masksToBounds = true
                            cell.imageView?.clipsToBounds = true
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                         }, withCancel: nil)
                         
                }
            cell.detailTextLabel?.text = message.text
            timeLabel.text = message.timeStamp
             
            
            cell.addSubview(timeLabel)
            timeLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            timeLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 18).isActive = true
            timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            timeLabel.heightAnchor.constraint(equalTo: cell.textLabel!.heightAnchor).isActive = true
            
                  
                  
              
              return cell
              
          }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
           performSegue(withIdentifier: "OwnerCellMessageSegue", sender: nil)
        
        
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
           
           func showChatControllerForUser(user: Users) {

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
               } else if segue.identifier == "OwnerCellMessageSegue" {
                guard let indexPath = tableView.indexPathForSelectedRow, let detailVC = segue.destination as? OwnerChatLogsViewController else{return}
                
                let message = messages[indexPath.row]
                  
                  guard let chatPartnerID = message.chatPartnerID() else {return}
                  
                  let ref = Database.database().reference().child("users").child(chatPartnerID)
                  ref.observe(.value, with: { (snapshot) in
                      
                      guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
                      let user = Users()
                      user.id = chatPartnerID
                      user.setValuesForKeys(dictionary)
                      detailVC.user = user
                      
                  }, withCancel: nil)
                
                
                
            }
               // Pass the selected object to the new view controller.
           }
           


    }
