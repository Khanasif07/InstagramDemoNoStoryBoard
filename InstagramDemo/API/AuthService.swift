//
//  AuthService.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit
import Firebase
import FirebaseAuth
struct AuthCredential{
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}
struct AuthService{
    static func logUserIn(withEmail email: String, password: String,completion: @escaping(AuthDataResult?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if let err = error{
                print(err)
                return
            }
            completion(authDataResult)
        }
    }
    
    static func registerUser(withCredential: AuthCredential,_ completion: @escaping(Error?)->Void){
        let imageUrl = "https://i.pravatar.cc/300".replaceLastThreeCharactersWithRandomNumbers()
          
//        ImageUploader.uploadImage(image: withCredential.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: withCredential.email, password: withCredential.password) { result, error in
                if let err = error{
                    print(err)
                    return
                }
                
                guard let uuid = result?.user.uid else { return }
                let data: [String:Any] = ["email": withCredential.email,"password": withCredential.password,"fullname": withCredential.fullName,"username": withCredential.userName,"profileImageUrl": imageUrl,"uid": uuid]
                
                Firestore.firestore().collection("users").document(uuid).setData(data,completion: completion
                )
//            }
        }
    }
}
