//
//  Notification.swift
//  InstagramDemo
//
//  Created by Asif Khan on 14/12/2024.
//

import Firebase
enum NotificationType: Int{
    case like
    case follow
    case comment
    
    var notificationMessage: String{
        switch self {
        case .like:
            return " liked your post."
        case .follow:
            return " started following you."
        default:
            return " commented on your post."
        }
    }
}
struct Notification{
    let uid: String
    let postImageUrl: String
    let postId: String
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImgUrl: String
    let username: String
    
    var userIsFollowed: Bool = false
    
    init (dictionary: [String:Any]){
        self.postId = dictionary["postId"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.userProfileImgUrl = dictionary["userProfileImgUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0)  ?? .like
        self.username = dictionary["username"] as? String ?? ""
    }
}
