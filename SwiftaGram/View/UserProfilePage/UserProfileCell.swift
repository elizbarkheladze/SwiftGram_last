//
//  UserProfileCell.swift
//  SwiftaGram
//
//  Created by alta on 9/7/22.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    
    //MARK: - Propertyies
    
    
    //MARK: - LifeCycle
    override init(frame:CGRect){
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
