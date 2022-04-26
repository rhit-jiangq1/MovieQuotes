//
//  storageManager.swift
//  MovieQuotes
//
//  Created by Qijun Jiang on 2022/4/26.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit


class StorageManager{
    static let shared = StorageManager()
    var _storageRef: StorageReference
    
    private init(){
        _storageRef = Storage.storage().reference()
    }
    
    func uploadProfilePhoto(uid: String, image: UIImage){
        guard let imageData = ImageUtils.resize(image: image)else{
            print("Converting the image to data failed")
            return
        }
        
        let photoRef = _storageRef.child(kUsersCollectionPath).child(uid)
        photoRef.putData(imageData)
        photoRef.putData(imageData, metadata: nil) { medadata, error in
            if let error = error{
                print("error occur for uploading image with error: \(error)")
                return
            }
            print("upload complete")
            
            photoRef.downloadURL { downloadUrl, error in
                if let error = error{
                    print("error occur for getting image with error: \(error)")
                    return
                }
                print("Get the download URL: \(downloadUrl?.absoluteString)")
                UserDocumentManager.shared.updateUrl(photoUrl: downloadUrl?.absoluteString ?? "")
            }
            
        }
        
    }
    
}
