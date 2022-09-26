//
//  UersPostViewModel.swift
//  SwiftaGram
//
//  Created by alta on 9/8/22.
//

import Foundation
import UIKit


struct UersPostViewModel {
     var userpost: UserPost
    
    var imageUrl: URL? {
        return URL(string: userpost.imageUrl)
    }
    
    var postTxtContent : String {
        return userpost.text
    }
    
    var userProfileImageUrl: URL?  {
        return URL(string: userpost.ownerImageUrl)
    }
    
    var publishersUsername : String {
        return userpost.ownerUsername
    }
    
    var timeString: String? {
        let format = DateComponentsFormatter()
        format.allowedUnits = [.second, .minute, .hour, .day]
        format.maximumUnitCount = 1
        format.unitsStyle = .abbreviated
        return format.string(from: userpost.time.dateValue(),to: Date())
    }

    var likes: Int {
        return userpost.like
    }
    
    var likesLabelText: String {
        return "\(userpost.like) likes"
    }
    
    var likeBtnColor : UIColor {
        return userpost.didLike ? .red : .black
    }
    var likeBtnImg : UIImage {
        let imageAddress = userpost.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageAddress)!
    }
    
    init(userpost: UserPost) {
        self.userpost = userpost
    }
}
