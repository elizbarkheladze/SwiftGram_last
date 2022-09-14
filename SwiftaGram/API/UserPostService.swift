//
//  UserPostService.swift
//  SwiftaGram
//
//  Created by alta on 9/8/22.
//

import Firebase
import UIKit


struct UserPostService {
    
    
    static func publishPost(text: String, picture: UIImage,user: User, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        PhotoUploader.uploadPhoto(image: picture) { url in
            let data = ["text": text , "time": Timestamp(date: Date()),"like" : 0,"imageUrl" : url,"publisherID" : uid,"ownerImageUrl" : user.profileImageUrl,"ownerUsername" : user.username] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([UserPost]) -> Void) {
        COLLECTION_POSTS.order(by: "time", descending: true).getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            let userPosts = docs.map({UserPost(postID: $0.documentID, dictionaty: $0.data())})
            completion(userPosts)
        }
    }
    
    static func fetchPostsForProfile(uid: String, completion: @escaping([UserPost]) -> Void) {
        let filtered = COLLECTION_POSTS.whereField("publisherID",isEqualTo: uid)
        
        filtered.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            var userPosts = docs.map({UserPost(postID: $0.documentID, dictionaty: $0.data())})
            
            userPosts.sort{(userPost,userPost2) -> Bool in
                return userPost.time.seconds > userPost2.time.seconds
            }
            completion(userPosts)
        }
    }
}
