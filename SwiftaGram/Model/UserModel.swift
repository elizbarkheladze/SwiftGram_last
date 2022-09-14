//
//  UserModel.swift
//  SwiftaGram
//
//  Created by alta on 9/7/22.
//

import Firebase
import FirebaseAuth


struct User {
    let email : String
    let name : String
    let profileImageUrl :  String
    let username : String
    let uid : String
    
    var isFollowed = false
    
    var stat: StatsofUser!
    
    var isLoggedInUser : Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionaty: [String:Any]){
        self.email = dictionaty["email"] as? String ?? ""
        self.name = dictionaty["name"] as? String ?? ""
        self.profileImageUrl = dictionaty["profileImageUrl"] as? String ?? ""
        self.username = dictionaty["username"] as? String ?? ""
        self.uid = dictionaty["uid"] as? String ?? ""
        
        self.stat = StatsofUser(followings: 0, followers: 0,postsCount: 0)
    }
}

struct StatsofUser {
    let followings: Int
    let followers: Int
    let postsCount : Int
}
