//
//  MainFeedCell.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit

protocol MainFeedCellDelegate : AnyObject {
    func tappedCommentsOnCell(_ cell: MainFeedCell, userPost : UserPost)
}
class MainFeedCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: MainFeedCellDelegate?
    
    var viewModel : UersPostViewModel? {
        didSet {
            configurePost()
        }
    }
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .red
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        return imageView
    }()
    
    private lazy var userButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Venom", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUser), for: .touchUpInside)
        return button
    }()
    
    
    private let postContectView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .red
        imageView.image = UIImage(imageLiteralResourceName: "venom-7")
        return imageView
    }()
    
    private lazy var likeBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private lazy var commentBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "comment"), for: .normal)
        button.addTarget(self, action: #selector(commentsTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    private lazy var shareBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likeLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let postTextContentLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLbl: UILabel = {
        let label = UILabel()
        label.text = "2 months ago"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(userImageView)
        userImageView.anchor(top: topAnchor,left: leftAnchor,
                             paddingTop: 12,
                             paddingLeft: 12)
        userImageView.setDimensions(height: 40,
                                    width: 40)
        userImageView.layer.cornerRadius = 40/2
        
        addSubview(userButton)
        userButton.centerY(inView: userImageView,
                           leftAnchor: userImageView.rightAnchor,
                           paddingLeft: 8)
        
        
        addSubview(postContectView)
        postContectView.anchor(top:userImageView.bottomAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               paddingTop: 8)
        
        postContectView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        actionButtonsConfigutation()
        
        addSubview(likeLbl)
        likeLbl.anchor(top: likeBtn.bottomAnchor,
                       left: leftAnchor,
                       paddingTop: -4,
                       paddingLeft: 8)
        
        addSubview(postTextContentLbl)
        postTextContentLbl.anchor(top: likeLbl.bottomAnchor,
                                  left: leftAnchor,
                                  paddingTop: 8,
                                  paddingLeft: 8)
        
        addSubview(postTimeLbl)
        postTimeLbl.anchor(top: postTextContentLbl.bottomAnchor,
                                  left: leftAnchor,
                                  paddingTop: 8,
                                  paddingLeft: 8)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
     
    @objc func didTapUser() {
        print("Did Tap User")
    }
    
    @objc func commentsTapped(){
        guard let viewModel = viewModel else {
            return
        }

        delegate?.tappedCommentsOnCell(self, userPost: viewModel.userpost)
    }
    
    //MARK: - Helpers
    
    func actionButtonsConfigutation() {
        let stackView = UIStackView(arrangedSubviews: [likeBtn,commentBtn,shareBtn])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postContectView.bottomAnchor,width: 120,height: 50)
    }
    
    func configurePost() {
        guard let viewModel = viewModel else {
            return
        }

        postTextContentLbl.text = viewModel.postTxtContent
        postContectView.sd_setImage(with: viewModel.imageUrl)
        userImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        userButton.setTitle(viewModel.publishersUsername, for: .normal)
        likeLbl.text = "\(viewModel.likes) likes"
        
    }
    
}

