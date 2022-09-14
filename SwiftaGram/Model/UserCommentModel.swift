//
//  UserCommentModel.swift
//  SwiftaGram
//
//  Created by alta on 9/14/22.
//

import Firebase

struct UserCommentModel {
    let uid : String
    let username : String
    let profileImageUrl : String
    let time : Timestamp
    let commentText : String
    
    init(dictionary: [ String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.time = dictionary["time"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictionary["commentText"] as? String ?? ""
    }
}
