//
//  UserNotificationService.swift
//  SwiftaGram
//
//  Created by alta on 9/15/22.
//

import Firebase

struct UserNotificationsService {
    static func sendUserNotification(uid: String,user: User, type: NotType, userPost: UserPost? = nil) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUserID else { return }
        let documentAddress = COLLECTION_NOTIFICATIONS.document(uid).collection("userNotifications").document()
        
        var data : [String: Any] = ["time": Timestamp(date: Date()),"uid": user.uid,"type": type.rawValue,"notificationID": documentAddress.documentID,"senderUserImageUrl": user.profileImageUrl ,"senderUsername": user.username]
        
        if let userPost = userPost {
            data["postID"] = userPost.postID
            data["postImageUrl"] = userPost.imageUrl
        }
        
        documentAddress.setData(data)
    }
    
    static func fetchUserNotifications(completion: @escaping([NotificationModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("userNotifications").getDocuments { snapshot, error in
            if let error = error {
                print("KAKA : \(error.localizedDescription)")
            }
            guard let document = snapshot?.documents else { return  }
            
            let notif = document.map({NotificationModel(dictionary: $0.data()) })
            completion(notif)
        }
    }
}
