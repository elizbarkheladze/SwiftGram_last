//
//  Userheader.swift
//  SwiftaGram
//
//  Created by alta on 9/7/22.
//

import UIKit
import SDWebImage

protocol UserHeaderDelegate : AnyObject {
    func header(_ userHeader: Userheader,didTap user:User)
}

class Userheader : UICollectionReusableView {
    
    //MARK: - Propertyies
    
    var viewModel : UserHeaderViewmodel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: UserHeaderDelegate?
    
    private let profilePictureImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let fullnameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editUserBtn : UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(editUser), for: .touchUpInside)
        return button
    }()
    
    private lazy var poststNumberLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var followersCountLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var followingCoutLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let postsCollectionBtn: UIButton = {
        let button =  UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "grid"),for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let postsTableBtn: UIButton = {
        let button =  UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "list"),for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let savedPostsBtn: UIButton = {
        let button =  UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "ribbon"),for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    
    //MARK: - LifeCycle
    override init(frame:CGRect){
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profilePictureImageView)
        profilePictureImageView.anchor(top:topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 12)
        profilePictureImageView.setDimensions(height: 80, width: 80)
        profilePictureImageView.layer.cornerRadius = 80/2
        
        addSubview(fullnameLbl)
        fullnameLbl.anchor(top:profilePictureImageView.bottomAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 12)
        addSubview(editUserBtn)
        editUserBtn.anchor(top:fullnameLbl.bottomAnchor,left: leftAnchor,
                           right: rightAnchor,paddingTop: 16,
                           paddingLeft: 24,paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [poststNumberLbl,followersCountLbl,followingCoutLbl])
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.centerY(inView: profilePictureImageView)
        stack.anchor(left:profilePictureImageView.rightAnchor,
                     right: rightAnchor,paddingLeft: 12,
                     paddingRight: 12,height: 50)
        
        let topSpacer = UIView()
        topSpacer.backgroundColor = .lightGray
        
        let bottomSpacer = UIView()
        bottomSpacer.backgroundColor = .lightGray
        
        let buttonsStack = UIStackView(arrangedSubviews: [postsCollectionBtn,postsTableBtn,savedPostsBtn])
        buttonsStack.distribution = .fillEqually
        
        addSubview(buttonsStack)
        addSubview(topSpacer)
        addSubview(bottomSpacer)
        
        buttonsStack.anchor(left:leftAnchor,bottom:bottomAnchor,right: rightAnchor,height: 50)
        
        topSpacer.anchor(top: buttonsStack.topAnchor,left: leftAnchor,right: rightAnchor,height: 0.5)
        bottomSpacer.anchor(top: buttonsStack.bottomAnchor,left: leftAnchor,right: rightAnchor,height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
        
    }
    
    //MARK: - Actions
    
    @objc func editUser(){
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTap: viewModel.user)
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }
        
        

        fullnameLbl.text = viewModel.name
        profilePictureImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        editUserBtn.setTitle(viewModel.followBtnText, for: .normal)
        editUserBtn.setTitleColor(viewModel.folowBtnTxtColour, for: .normal)
        editUserBtn.backgroundColor = viewModel.followBtnColour
        
        followersCountLbl.attributedText = viewModel.followersCount
        poststNumberLbl.attributedText = viewModel.postsCount
        followingCoutLbl.attributedText = viewModel.followingsCount
        
    }
    

}
