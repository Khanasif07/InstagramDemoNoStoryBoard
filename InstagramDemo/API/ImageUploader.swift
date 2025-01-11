//
//  ImageUploader.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//
import FirebaseStorage
import UIKit
struct ImageUploader{
    static func uploadImage(image: UIImage,completion: @escaping (String)-> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        ref.putData(imageData, metadata: nil) { metaData, err in
            if let error = err{
                print(error)
                return
            }
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
