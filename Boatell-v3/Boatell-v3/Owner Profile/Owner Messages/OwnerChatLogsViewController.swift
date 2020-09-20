//
//  OwnerChatLogsViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class OwnerChatLogsViewController: UIViewController {

        var user: User? {
            didSet{
                self.navigationItem.title = user?.name
                print("USER: \(user?.name)")
            }
            
        }
        
        @IBOutlet var messageTextField: UITextField!
        
        
        @IBOutlet var messagesCollectionView: UICollectionView!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            

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
            childRef.updateChildValues(values)
            
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
