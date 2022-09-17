//
//  NotificationModel.swift
//  SwiftaGram
//
//  Created by alta on 9/15/22.
//

import Firebase

enum NotType : Int {
    case liked
    case followed
    case commented
    
    var notTxt : String {
        switch self {
        case .liked : return " Liked your post"
        case .followed : return " followed you"
        case .commented : return " commented on your post"
        }
    }
}

struct NotificationModel {
    let uid: String
    var postImageUrl:String?
    var postID: String?
    var time : Timestamp
    let notificationID : String
    let type: NotType
    let senderUserImageUrl: String
    let senderUsername: String
    
    
    init(dictionary: [String : Any]) {
        self.time = dictionary["time"] as? Timestamp ?? Timestamp(date: Date())
        self.uid = dictionary["uid"] as? String ?? " "
        self.notificationID = dictionary["notificationID"] as? String ?? " "
        self.postID = dictionary["postID"] as? String ?? " "
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? " "
        self.senderUserImageUrl = dictionary["senderUserImageUrl"] as? String ?? " "
        self.senderUsername = dictionary["senderUsername"] as? String ?? " "
        self.type = NotType(rawValue: dictionary["type"] as? Int ?? 0) ?? .liked
        
    }
}
