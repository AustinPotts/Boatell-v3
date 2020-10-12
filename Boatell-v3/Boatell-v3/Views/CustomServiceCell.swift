//
//  CustomServiceCell.swift
//  Boatell-v3
//
//  Created by Austin Potts on 10/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Firebase

class CustomServiceCell: UICollectionViewCell {
       
       var data: FirebaseServices? {
           didSet{
               guard let data = data else {return}
             //  bg.image = data.serviceImage
               self.bg.loadImageViewUsingCacheWithUrlString(urlString: data.serviceImage!)
               labelViewText.text = data.serviceName
               priceLabel.text = data.servicePrice

           }
       }
       
       fileprivate let bg: UIImageView = {
           let iv = UIImageView()
           iv.image = #imageLiteral(resourceName: "Cut")
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.layer.cornerRadius = 15
           
           return iv
       }()
       
       fileprivate let blackLabelView: UIView = {
              let view = UIView()
              view.backgroundColor = .black
              view.alpha = 0.8
              view.translatesAutoresizingMaskIntoConstraints = false

              return view
          }()
          
          fileprivate let labelViewText: UILabel = {
              let label = UILabel()
              label.text = "Name"
              label.textColor = UIColor.white
              label.font.withSize(16)
              label.translatesAutoresizingMaskIntoConstraints = false

              return label
          }()
       
       fileprivate let priceLabel: UILabel = {
           let priceLabel = UILabel()
           priceLabel.text = "$10.00"
           priceLabel.font.withSize(7)
           priceLabel.textColor = UIColor.darkText
           priceLabel.translatesAutoresizingMaskIntoConstraints = false
           return priceLabel
       }()
       
       fileprivate let priceView: UIView = {
          let priceView = UIView()
           priceView.backgroundColor = .green
           priceView.layer.cornerRadius = 5
           priceView.alpha = 0.9
           priceView.translatesAutoresizingMaskIntoConstraints = false
           return priceView
       }()
          
          override init(frame: CGRect) {
              super.init(frame: frame)
              contentView.addSubview(bg)
              bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
              bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
              bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
              bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
              
              bg.addSubview(blackLabelView)
              blackLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
              blackLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
              blackLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
              blackLabelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
              
           blackLabelView.addSubview(labelViewText)
           labelViewText.centerYAnchor.constraint(equalTo: blackLabelView.centerYAnchor).isActive = true
           labelViewText.centerXAnchor.constraint(equalTo: blackLabelView.centerXAnchor).isActive = true
       
           
           bg.addSubview(priceView)
           priceView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
           priceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
          // priceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -75).isActive = true
           priceView.heightAnchor.constraint(equalToConstant: 30).isActive = true
           priceView.widthAnchor.constraint(equalToConstant: 65).isActive = true
           
           priceView.addSubview(priceLabel)
           priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 5).isActive = true
           priceLabel.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 5).isActive = true

           
           
           

          }
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       
   }
