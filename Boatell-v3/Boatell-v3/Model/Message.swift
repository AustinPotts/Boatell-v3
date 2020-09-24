//
//  Message.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Firebase

class Message: NSObject {
    
    @objc var fromID: String?
    @objc var text: String?
    @objc var timeStamp: String?
    @objc var toID: String?
    
    func chatPartnerID() -> String? {
        
        
        if fromID == Auth.auth().currentUser?.uid{
            return toID
            
        } else {
            return fromID
        }
        
    }
    
}
