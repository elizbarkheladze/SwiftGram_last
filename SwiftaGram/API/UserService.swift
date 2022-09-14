//
//  UserService.swift
//  SwiftaGram
//
//  Created by alta on 9/7/22.
//

import Firebase


struct UserService {
    static func fetchUser(uid: String,completion: @escaping(User) -> Void){
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionaty: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion:  @escaping([User]) -> Void){
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            let users = snapshot.documents.map ({User(dictionaty: $0.data() )})
            completion(users)
        }
    }
    
    static func followUser(uid: String, completion: @escaping(Error?) -> Void) {
        guard let currentuid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWEINGS.document(currentuid).collection("user-followings").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentuid).setData([:], completion: completion)
        }
    }
    
    static func unFollowUser(uid: String, completion: @escaping(Error?) -> Void) {
        guard let currentuid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWEINGS.document(currentuid).collection("user-followings").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentuid).delete(completion: completion)
        }
    }
    
    static func isUserFollowed(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentuid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWEINGS.document(currentuid).collection("user-followings").document(uid).getDocument { snapshot, error in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    static func fetchStatsofUser(uid: String, completion: @escaping(StatsofUser) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, error) in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWEINGS.document(uid).collection("user-followings").getDocuments { snapshot, error in
                let followings = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("publisherID", isEqualTo: uid).getDocuments { snapshot, error in
                    let postsCount = snapshot?.documents.count ?? 0
                    completion(StatsofUser(followings: followings, followers: followers,postsCount: postsCount))
                }
                
                
            }
        }
    }
}
