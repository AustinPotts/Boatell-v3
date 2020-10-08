//
//  User.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation



class Users: NSObject {
    
    @objc var id: String?
    @objc var name: String?
    @objc var email: String?
    @objc var profileImageURL: String?
    @objc var confirmDate: Confirm?
    @objc var confirmService: Confirm?
    @objc var confirmPrice: Confirm?
    @objc var confirmed: NSString?
    
    //Fix this snake case after positive test
    @objc var customer_id: String?
    
    
}
