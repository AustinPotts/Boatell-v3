//
//  ChatMessageCollectionViewCell.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "sample"
        tv.font?.withSize(18)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        return tv
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
    
   override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    addSubview(bubbleView)
    bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
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
    
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
