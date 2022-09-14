//
//  UserCell.swift
//  SwiftaGram
//
//  Created by alta on 9/7/22.
//

import UIKit
class UserCell: UICollectionViewCell {
    
    
    //MARK: - Propertyies
    private let postedImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var viewModel : UersPostViewModel? {
        didSet{
            configurePost()
        }
    }
    
    //MARK: - LifeCycle
    override init(frame:CGRect){
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(postedImageView)
        postedImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePost(){
        guard let viewModel = viewModel else {
            return
        }
        postedImageView.sd_setImage(with: viewModel.imageUrl)
    }
}
