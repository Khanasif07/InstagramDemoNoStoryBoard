//
//  User.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import Foundation
import FirebaseAuth
struct User{
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    var profileImageUrl: String?
    var uid: String?
    
    var stats: UserStats?
    
    var isFollowed = false
    var isCurrentUser:Bool  {return Auth.auth().currentUser?.uid == uid}
    
    init (dictionary: [String:Any]){
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

struct UserStats{
    let followers: Int
    let following: Int
    let posts: Int
}
