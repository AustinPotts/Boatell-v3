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
    @IBOutlet var userName: UILabel!
    
    //MARK: - User Property Observer
     var confirmed: FirebaseConfirm? {
         didSet {
             updateViews()
             //updateViews2()
         }
     }
    
    //MARK: - Update Views Once Property Is Observed
      func updateViews(){
        
       
        if let serviceNameUnwrap = confirmed?.confirmService! {
            serviceName.text = serviceNameUnwrap
        }
        
        
        servicePrice.text = confirmed!.confirmPrice
        serviceDate.text = confirmed!.confirmDate
        userName.text = confirmed!.userName
        
        
        servicePriceView.layer.cornerRadius = 15
        
          
          if let confirmImageURL = confirmed!.confirmImage {

                   confirmImage.loadImageViewUsingCacheWithUrlString(urlString: confirmImageURL)
            confirmImage.layer.cornerRadius = 20

          }
      }
    
    func updateViews2(){
             let uid = Auth.auth().currentUser?.uid

               Database.database().reference().child("users").child(uid!).child("confirmed").observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 
                       print(snapshot)
                       if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                       
                         //MARK: - This is being found Nil
                        self.serviceName.text = dictionary["confirmService"] as? String
                         let confirmedImage = dictionary["confirmImage"] as? String
                         self.confirmImage.loadImageViewUsingCacheWithUrlString(urlString: confirmedImage!)
                        
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
