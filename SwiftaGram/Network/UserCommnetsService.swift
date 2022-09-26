//
//  UserCommnetsService.swift
//  SwiftaGram
//
//  Created by alta on 9/14/22.
//

import Firebase

struct UserCommentsService {
    static func publishComment(commentText: String,userPostID: String,user: User,completion: @escaping(Error?) -> Void){
        let data : [String: Any] = ["uid": user.uid , "commentText" : commentText,"time" : Timestamp(date: Date()),"username": user.username,"profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POSTS.document(userPostID).collection("comments").addDocument(data: data, completion: completion)
    }
    
    static func fetchComments(postID : String,completion: @escaping([UserCommentModel]) -> Void){
        var userComments = [UserCommentModel]()
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "time", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({change in
                if change.type == .added{
                    let dictionary = change.document.data()
                    let userComment = UserCommentModel(dictionary: dictionary)
                    userComments.append(userComment)
                }
            })
            
            completion(userComments)
        }
    }
}
