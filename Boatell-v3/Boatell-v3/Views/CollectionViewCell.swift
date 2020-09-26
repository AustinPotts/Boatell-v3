//
//  ChatMessageCollectionViewCell.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

//MARK: - Collection View Cell for Messages
class CollectionViewCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "sample"
        tv.font?.withSize(24)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        return tv
    }()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Lights")
        image.layer.cornerRadius = 32
        image.layer.masksToBounds = false
        image.layer.cornerRadius = (image.frame.height) / 2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
   override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    addSubview(bubbleView)
    bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
    bubbleViewRightAnchor?.isActive = true
    
    bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
    //bubbleViewLeftAnchor?.isActive = true
    
    
    
    bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    
    bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
    bubbleWidthAnchor?.isActive = true
    bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    
    
    bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
    addSubview(textView)
    
    textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
    textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    
    textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
   // textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    
    
    textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
    addSubview(profileImageView)
    profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
    
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
