//
//  OwnerChatLogsViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class OwnerChatLogsViewController: UIViewController, UICollectionViewDelegate {

        var user: User? {
            didSet{
                self.navigationItem.title = user?.name
                print("USER: \(user?.name)")
                observeMessages()
            }
            
        }
    
    var messages = [Message]()
    
    func observeMessages(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messagesID = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messagesID)
            
            messagesRef.observe(.value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
                let message = Message()
                
                // Potential of crashing if keys dont match
                message.setValuesForKeys(dictionary)
                
                if message.chatPartnerID() == self.user?.id {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.messagesCollectionView.reloadData()
                        
                    }
                }
                
                
                
              
                
            }, withCancel: nil)
        }, withCancel: nil)
        
        
        
    }
        
        @IBOutlet var messageTextField: UITextField!
        
        
        @IBOutlet var messagesCollectionView: UICollectionView!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            messagesCollectionView.delegate = self
            messagesCollectionView.dataSource = self
            messagesCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MessageCell")

        }
    
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            // messageTextField.delegate! = self
            self.navigationItem.title = user?.name
            
        }

      
        
        
        @IBAction func sendTapped(_ sender: Any) {
            handleSend()
        }
        
        func handleSend() {
            
            //guard let message = messageTextField.text else {return}
            
            
            
            let ref = Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            
            let toID = user!.id!
            let fromID = Auth.auth().currentUser!.uid
            let timeStamp = String(NSDate().timeIntervalSince1970)
            
            let values = ["text": messageTextField.text!, "toID" : toID, "fromID" : fromID, "timeStamp" : timeStamp]
           // childRef.updateChildValues(values)
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID)
            let messageID = childRef.key!
            userMessagesRef.updateChildValues([messageID: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID)
            recipientUserMessagesRef.updateChildValues([messageID: 1])
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print("Error child ref: \(error)")
                    return
                }
                
                print("MESSAGE ID: \(messageID)")
            
        }
        
    }
    
    
    
    
    
    
    
    
    
}

//MARK: - Collection View Set Up
extension OwnerChatLogsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.messagesCollectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! CollectionViewCell
        //cell.backgroundColor = .black
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        return cell
    }
    
    
}

    //
    //extension ChatLogsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        <#code#>
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        <#code#>
    //    }
    //
    //
    //}


    extension OwnerChatLogsViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            handleSend()
            return true
        }
    }
