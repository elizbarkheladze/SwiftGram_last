//
//  UserHeaderViewModel.swift
//  SwiftaGram
//
//  Created by alta on 9/7/22.
//

import Foundation
import UIKit

struct UserHeaderViewmodel {
    let user: User
    
    var name : String {
        return user.name
    }
    
    var profileImageUrl : URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followBtnText : String {
        if user.isLoggedInUser {
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followBtnColour : UIColor {
        return user.isLoggedInUser ? .white : .systemBlue
    }
    
    var folowBtnTxtColour : UIColor {
        return user.isLoggedInUser ? .black : .white
    }
    
    var followersCount : NSAttributedString {
        return attedText(count: user.stat.followers, txt: "Followers")
    }
    var followingsCount : NSAttributedString {
        return attedText(count: user.stat.followings, txt: "Followings")
    }
    
    var postsCount: NSAttributedString {
        return attedText(count: user.stat.postsCount, txt: "Posts")
    }
    
    
    init(user:User){
        self.user = user
    }
    
    func attedText(count: Int,txt: String) -> NSAttributedString {
        let attedText = NSMutableAttributedString(string: "\(count)\n",
                                                  attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attedText.append(NSAttributedString(string: txt,
                                            attributes: [.font:UIFont.systemFont(ofSize: 14),
                                                                      .foregroundColor: UIColor.lightGray]))
        return attedText
    }
}
