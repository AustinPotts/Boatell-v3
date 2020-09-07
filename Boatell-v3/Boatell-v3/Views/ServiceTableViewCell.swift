//
//  ServiceTableViewCell.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    
    
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var serviceName: UILabel!
    @IBOutlet var serviceDate: UILabel!
    @IBOutlet var servicePriceView: UIView!
    @IBOutlet var servicePrice: UILabel!
    
    //MARK: - User Property Observer
     var confirmed: FirebaseConfirm? {
         didSet {
             updateViews()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
