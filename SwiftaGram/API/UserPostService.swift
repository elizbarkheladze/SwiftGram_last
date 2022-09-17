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
    
    static func postLiked(userPost: UserPost, completion : @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(userPost.postID).updateData(["like": userPost.like + 1])
        
        COLLECTION_POSTS.document(userPost.postID).collection("postLikes").document(uid).setData([:]) { error in
            COLLECTION_USERS.document(uid).collection("userLikedPosts").document(userPost.postID).setData([:], completion: completion)
        }
        
    }
    
    static func hasUserLikedPost(userPost: UserPost, completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("userLikedPosts").document(userPost.postID).getDocument { snapshot, error in
            if let error = error {
                print("KAKA  \(error.localizedDescription)")
            }
            guard let isLiked = snapshot?.exists else {return}
            completion(isLiked)
        }
        
        
    }
    
    
    static func postUnliked(userPost: UserPost, completion : @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard userPost.like > 0 else {return}
        
        COLLECTION_POSTS.document(userPost.postID).updateData(["like": userPost.like - 1])
        
        COLLECTION_POSTS.document(userPost.postID).collection("postLikes").document(uid).delete { error in
            COLLECTION_USERS.document(uid).collection("userLikedPosts").document(userPost.postID).delete(completion: completion)
        }
    }
}
