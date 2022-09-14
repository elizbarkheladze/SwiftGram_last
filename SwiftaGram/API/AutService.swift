//
//  AutService.swift
//  SwiftaGram
//
//  Created by alta on 9/6/22.
//
import FirebaseStorage
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import UIKit


struct AuthInfo {
    let email: String
    let password: String
    let name: String
    let username: String
    let profileImage: UIImage
    
}


struct AutService {
    static func logUserIn(email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
    }
    
    static func registerUser(userinfo: AuthInfo, completion: @escaping(Error?) -> Void){
        print("credentidasdasdals : \(userinfo)")
        
        PhotoUploader.uploadPhoto(image: userinfo.profileImage) { ImageUrl in
            print("----------------------")
            Auth.auth().createUser(withEmail: userinfo.email, password: userinfo.password) { (resault, error) in
                
                if let error = error {
                    print("User Couldn not be registered , Because: \(error.localizedDescription)")
                    return
                }
                print("DEBUG: asdasd")
                guard let uid = resault?.user.uid else { return }
                
                let data : [String:Any] = ["email" : userinfo.email,
                                           "name" : userinfo.name,
                                           "profileImageUrl" : ImageUrl,
                                           "username" : userinfo.username,
                                           "uid" : uid,]
                
                COLLECTION_USERS.document(uid).setData(data,completion: completion)
            }
            
        }
    }
}
