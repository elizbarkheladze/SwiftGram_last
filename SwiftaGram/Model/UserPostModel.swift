//
//  UserPostModel.swift
//  SwiftaGram
//
//  Created by alta on 9/8/22.
//

import Firebase


struct UserPost {
    var text: String
    var like: Int
    let imageUrl: String
    let publisherID: String
    let time: Timestamp
    let postID : String
    let ownerImageUrl: String
    let ownerUsername: String
    
    init(postID: String,dictionaty: [String:Any]){
        self.postID = postID
        self.text = dictionaty["text"] as? String ?? ""
        self.like = dictionaty["like"] as? Int ?? 0
        self.imageUrl = dictionaty["imageUrl"] as? String ?? ""
        self.publisherID = dictionaty["publisherID"] as? String ?? ""
        self.time = dictionaty["time"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerImageUrl = dictionaty["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionaty["ownerUsername"] as? String ?? ""
    }
}
