//
//  UserCommentsViewModel.swift
//  SwiftaGram
//
//  Created by alta on 9/14/22.
//

import UIKit

struct UserCommentsViewModel {
    private let userComment: UserCommentModel
    
    var profileImageUrl: URL?{
        return URL(string: userComment.profileImageUrl)
    }
    
    var username: String {
        return userComment.username
    }
    
    var commentTxt : String {
        return userComment.commentText
    }
    
    init(userComment: UserCommentModel){
        self.userComment = userComment
    }
    
    func configureCommentTextLabel() -> NSAttributedString {
        let attedString = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attedString.append(NSAttributedString(string: commentTxt, attributes: [.font:UIFont.systemFont(ofSize: 16)]))
        return attedString
    }
    
    func cellSize(width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = userComment.commentText
        label.lineBreakMode  = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
