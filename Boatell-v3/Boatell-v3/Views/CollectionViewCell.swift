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
        return tv
    }()
    
   override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.red
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
