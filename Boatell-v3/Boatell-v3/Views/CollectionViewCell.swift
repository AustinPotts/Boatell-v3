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
        return tv
    }()
    
   override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(textView)
    
    textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
