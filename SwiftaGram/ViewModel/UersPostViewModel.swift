//
//  UersPostViewModel.swift
//  SwiftaGram
//
//  Created by alta on 9/8/22.
//

import Foundation


struct UersPostViewModel {
     let userpost: UserPost
    
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
    
    var likes: Int {
        return userpost.like
    }
    
    init(userpost: UserPost) {
        self.userpost = userpost
    }
}
