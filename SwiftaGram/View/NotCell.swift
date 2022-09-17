//
//  NotCell.swift
//  SwiftaGram
//
//  Created by alta on 9/15/22.
//

import UIKit

class NotCell : UITableViewCell {
    
    var viewModel: UserNotificationsViewModel? {
        didSet {
            configureNotifications()
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
    
    private let notificationTxt : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        label.numberOfLines = 0
        return label
    }()
    
    private let imageofPost: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userPostTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    private let followBtn: UIButton = {
        let button = UIButton()
        button.setTitle("follow", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(followBtnTapped), for: .touchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(userProfileImage)
        userProfileImage.setDimensions(height: 44, width: 44)
        userProfileImage.layer.cornerRadius = 44/2
        userProfileImage.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        
        addSubview(notificationTxt)
        notificationTxt.centerY(inView: userProfileImage,leftAnchor: userProfileImage.rightAnchor,paddingLeft: 8)
        
        addSubview(followBtn)
        followBtn.centerY(inView: self)
        followBtn.anchor(right: rightAnchor,paddingRight: 12,width: 100,height: 32)
        
        addSubview(imageofPost)
        imageofPost.centerY(inView: self)
        imageofPost.anchor(right: rightAnchor,paddingRight: 12,width: 32,height: 32)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func followBtnTapped() {
        
    }
    
    @objc func userPostTapped() {
        
    }
    
    func configureNotifications() {
        guard let viewModel = viewModel else { return }
        
        userProfileImage.sd_setImage(with: viewModel.userImageUrl)
        imageofPost.sd_setImage(with: viewModel.postImageUrl)
        
        notificationTxt.attributedText = viewModel.notifTxt
    }
}
