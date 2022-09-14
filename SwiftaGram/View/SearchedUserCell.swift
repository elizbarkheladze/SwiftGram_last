//
//  SearchedUserCell.swift
//  SwiftaGram
//
//  Created by alta on 9/8/22.
//

import UIKit

class SearchedUserCell : UITableViewCell {
    
    //MARK: - Properties
    var ViewModel : ProfileCellViewModel? {
        didSet{
            configureCell()
        }
    }
    
    
    private let userProfileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        return imageView
    }()
    
    private let nameTxtLbl : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.textColor = .lightGray
        label.text = "elizbar"
        return label
    }()
    
    private let userNameTxtLbl : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "elizbar.khel"
        return label
    }()
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(userProfileImage)
        userProfileImage.setDimensions(height: 44, width: 44)
        userProfileImage.layer.cornerRadius = 44/2
        userProfileImage.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [userNameTxtLbl,nameTxtLbl])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: userProfileImage, leftAnchor: userProfileImage.rightAnchor,paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureCell() {
        guard let ViewModel = ViewModel else {
            return
        }
        
        userProfileImage.sd_setImage(with: ViewModel.profileImageUrl)
        userNameTxtLbl.text = ViewModel.username
        nameTxtLbl.text = ViewModel.name
            
    }
}
