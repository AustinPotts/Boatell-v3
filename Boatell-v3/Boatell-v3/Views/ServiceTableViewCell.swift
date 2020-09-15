//
//  ServiceTableViewCell.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class ServiceTableViewCell: UITableViewCell {
    
    
    @IBOutlet var confirmImage: UIImageView!
    @IBOutlet var serviceName: UILabel!
    @IBOutlet var serviceDate: UILabel!
    @IBOutlet var servicePriceView: UIView!
    @IBOutlet var servicePrice: UILabel!
    
    //MARK: - User Property Observer
     var confirmed: FirebaseConfirm? {
         didSet {
             updateViews()
            // updateViews2()
         }
     }
    
    //MARK: - Update Views Once Property Is Observed
      func updateViews(){
        
        serviceName.text = confirmed?.confirmService
        servicePrice.text = confirmed?.confirmPrice
        serviceDate.text = confirmed?.confirmDate
        
        
        servicePriceView.layer.cornerRadius = 15
        
          
//          if let profileImageUrl = confirmed!.profileImageURL {
//
//                   usersImage.loadImageViewUsingCacheWithUrlString(urlString: profileImageUrl)
//
//          }
      }
    
    func updateViews2(){
             let uid = Auth.auth().currentUser?.uid

               Database.database().reference().child("users").child(uid!).child("confirmed").observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 
                       print(snapshot)
                       if let dictionary = snapshot.value as? [String: AnyObject] {
                         let confirmImage = dictionary["confirmImage"] as? String
                         self.confirmImage.loadImageViewUsingCacheWithUrlString(urlString: confirmImage!)
                         self.confirmImage.layer.cornerRadius = self.confirmImage.frame.height / 2
                         self.confirmImage.layer.masksToBounds = false
                         self.confirmImage.clipsToBounds = true
                       }
                       
                   }, withCancel: nil)
         }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
