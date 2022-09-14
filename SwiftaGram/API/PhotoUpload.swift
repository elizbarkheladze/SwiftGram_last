//
//  PhotoUpload.swift
//  SwiftaGram
//
//  Created by alta on 9/6/22.
//

import FirebaseStorage
import Firebase
import FirebaseFirestore
import FirebaseAuth
import UIKit

struct PhotoUploader{
    static func handlePhotos(image:UIImage,completion : @escaping(String) -> Void){
        
    }
    static func uploadPhoto(image : UIImage , completion : @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference()
        let path = "profile_images/\(filename)"
        let filepath = ref.child(path)
        
        filepath.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("could not upload image , because: \(error.localizedDescription)")
                return
            }else {
                filepath.downloadURL { url , error  in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                        guard let imageUrl = url?.absoluteString else { return }
                        print("adadads")
                    print("--------------\(imageUrl)")
                        completion(imageUrl)
                        print("adadads")
                }
            }
        }

        
    }
}
