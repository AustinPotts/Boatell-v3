//
//  Owner.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation


class Owner: NSObject {
    
    @objc var id: String?
    @objc var name: String?
    @objc var email: String?
    @objc var profileImageURL: String?
    @objc var confirmDate: Confirm?
    @objc var confirmedServices: Confirm?
    @objc var confirmPrice: Confirm?
    @objc var confirmed: NSString?
    
    
}
