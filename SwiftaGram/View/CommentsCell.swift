//
//  CommentsCell.swift
//  SwiftaGram
//
//  Created by alta on 9/14/22.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    var viewModel : UserCommentsViewModel? {
        didSet {
            configureUserComments()
        }
    }
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let commentTextLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userProfileImageView)
        userProfileImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 5)
        userProfileImageView.setDimensions(height: 40, width: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        commentTextLbl.numberOfLines = 0
        addSubview(commentTextLbl)
        commentTextLbl.centerY(inView: userProfileImageView,leftAnchor: userProfileImageView.rightAnchor ,paddingLeft: 8)
        commentTextLbl.anchor(right:rightAnchor,paddingRight: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUserComments(){
        guard let viewModel = viewModel else {
            return
        }
        userProfileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        commentTextLbl.attributedText = viewModel.configureCommentTextLabel()
    }
    
}
