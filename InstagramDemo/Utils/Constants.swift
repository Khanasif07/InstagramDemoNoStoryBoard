//
//  Constants.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import Foundation
import Firebase

let Collection_Users = Firestore.firestore().collection("users")
let Collection_Followers = Firestore.firestore().collection("followers")
let Collection_Following = Firestore.firestore().collection("following")
let Collection_Posts = Firestore.firestore().collection("posts")
let Collection_Notifications = Firestore.firestore().collection("notifications")
