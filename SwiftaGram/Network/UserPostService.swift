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
            
            
            
            let doc = COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
            self.updatePostsAfterNewPost(postID: doc.documentID)
        }
    }
    static func fetchSinglePost(postID: String,completion : @escaping(UserPost) -> Void) {
        COLLECTION_POSTS.document(postID).getDocument { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let userPost = UserPost(postID: snapshot.documentID, dictionaty: data)
            completion(userPost)
        }
    }
    
    static func fetchPosts(completion: @escaping([UserPost]) -> Void) {
        COLLECTION_POSTS.order(by: "time", descending: true).getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            let userPosts = docs.map({UserPost(postID: $0.documentID, dictionaty: $0.data())})
            completion(userPosts)
        }
    }
    
    static func updatePostsAfterFollow(user: User,followIndicator: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = COLLECTION_POSTS.whereField("publisherID", isEqualTo: user.uid)
        query.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            let docIDs = docs.map{$0.documentID}
            docIDs.forEach { docID in
                if followIndicator {
                    COLLECTION_USERS.document(uid).collection("usersFeed").document(docID).setData([:])
                } else {
                    COLLECTION_USERS.document(uid).collection("usersFeed").document(docID).delete()
                }
                
            }
        }
    }
    
    private static func updatePostsAfterNewPost(postID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            docs.forEach { doc in
                COLLECTION_USERS.document(doc.documentID).collection("usersFeed").document(postID).setData([:])
            }
        }
    }
    
    static func fetchPostsForFeed(completion: @escaping([UserPost]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("usersFeed").getDocuments { snapshot, error in
            var userPosts = [UserPost]()
            snapshot?.documents.forEach({ doc in
                fetchSinglePost(postID: doc.documentID) { userPost in
                    userPosts.append(userPost)
                    
                    userPosts.sort(by: {$0.time.seconds > $1.time.seconds})
    
                    completion(userPosts)
                }
                
            })
        }
    }
    
    static func fetchPostsForProfile(uid: String, completion: @escaping([UserPost]) -> Void) {
        let filtered = COLLECTION_POSTS.whereField("publisherID",isEqualTo: uid)
        
        filtered.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            var userPosts = docs.map({UserPost(postID: $0.documentID, dictionaty: $0.data())})
            
            userPosts.sort(by: {$0.time.seconds > $1.time.seconds})
            
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
