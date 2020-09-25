//
//  ChatLogsViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class ChatLogsViewController: UIViewController, UICollectionViewDelegate {

  
      
    
    var owner: Owner? {
        didSet {
            self.navigationItem.title = owner?.name
               print("USER: \(owner?.name)")
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
                
               // if message.chatPartnerID() == self.owner?.id {
                    self.messages.append(message)
                    
                if message.chatPartnerID() == "fj94U7Y9GgdMDbljI6nuW0NQZXp2" {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.messagesCollectionView.reloadData()
                        
                    }
                }
               // }
                
                
                
              
                
            }, withCancel: nil)
        }, withCancel: nil)
        
        print("MESSAGES COUNT \(messages.count)")
        
        
    }
        
        @IBOutlet var messageTextField: UITextField!
        
   
    
        @IBOutlet var messagesCollectionView: UICollectionView!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            messagesCollectionView.delegate = self
            messagesCollectionView.dataSource = self
            messagesCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MessageCell")
            messagesCollectionView.alwaysBounceVertical = true
            messagesCollectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
            observeMessages()

        }
    
    
    
        @IBAction func sendTapped(_ sender: Any) {
            handleSend()
        
        }
        
        func handleSend() {
            
            //guard let message = messageTextField.text else {return}
            
            let ref = Database.database().reference().child("messages")
            let childRef = ref.childByAutoId()
           // print("OWNER ID: \(owner?.id)")
             let toID = "fj94U7Y9GgdMDbljI6nuW0NQZXp2"
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


    extension ChatLogsViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            handleSend()
            return true
        }
    }

//MARK: - Collection View Set Up
extension ChatLogsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
              
              
              // Get estimated HEight
              if let text = messages[indexPath.item].text {
                height = esitmatedFrame(text).height + 20
              }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func esitmatedFrame(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.messagesCollectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! CollectionViewCell
        //cell.backgroundColor = .black
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        if let profileImageURL = owner?.profileImageURL{
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageURL)

        }
        
        if message.fromID == Auth.auth().currentUser?.uid {
                //outgoing blue
                cell.bubbleView.backgroundColor = .systemBlue
                cell.textView.textColor = .white
                cell.profileImageView.isHidden = true
                cell.bubbleViewRightAnchor?.isActive = true
                cell.bubbleViewLeftAnchor?.isActive = false
            } else {
               // incoming gray message
                cell.bubbleView.backgroundColor = .lightGray
                cell.textView.textColor = .black
                cell.bubbleViewRightAnchor?.isActive = false
                cell.bubbleViewLeftAnchor?.isActive = true
                cell.profileImageView.isHidden = false


                
            }
        
        //fix force unwrap
        cell.bubbleWidthAnchor?.constant = esitmatedFrame(message.text!).width + 32
        
        return cell
    }
    
    
}
