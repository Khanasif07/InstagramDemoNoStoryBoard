//
//  NotificationViewModel.swift
//  InstagramDemo
//
//  Created by Asif Khan on 14/12/2024.
//

import Foundation
import UIKit
struct NotificationViewModel{
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? {
        return URL(string: notification.postImageUrl )
    }
      
    var profileImgUrl: URL?{
        return URL(string: notification.userProfileImgUrl )
    }
    
    var notificationMessage: NSAttributedString{
        let username = notification.username
        let message = notification.type.notificationMessage
        let attributedText = NSMutableAttributedString(string: username,attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message,attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: timeAgo(),attributes: [.foregroundColor: UIColor.lightGray,.font: UIFont.systemFont(ofSize: 12)]))
        return attributedText
    }
    
    var shouldHidePostImage: Bool{
        return notification.type == .follow
    }
    
    var shouldHideFollowButton: Bool{
        return notification.type != .follow
    }
    
    var followButtonText: String{
        return notification.userIsFollowed ? "following" : "follow"
    }
    
    var followButtonBGColor: UIColor{
        return notification.userIsFollowed ? .white : .systemBlue
    }
    var followButtonTextColor: UIColor{
        return notification.userIsFollowed ? .black : .white
    }
    
    func timeAgo() -> String {
        // Convert timestamp to Date
        let date = notification.timestamp.dateValue()
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full // Options: .full, .short, .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
