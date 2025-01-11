//
//  ProfileHeaderViewModel.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import Foundation
import UIKit
struct ProfileHeaderViewModel{
    let user: User
    init(user: User) {
        self.user = user
    }
    
    var fullname: String{
        return user.fullname ?? ""
    }
    var profileImageUrl: URL{
        return URL(string: user.profileImageUrl ?? "")!
    }
    
    var followButtonText: String{
        if user.isCurrentUser{
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor{
        return user.isFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor{
        return user.isFollowed ? .black : .white
    }
    
    var numberOfFollowers: NSAttributedString{
        return attrStatText(value: user.stats?.followers ?? 0, label: "followers")
    }
    
    var numberOfPosts: NSAttributedString{
        return attrStatText(value: user.stats?.posts ?? 0, label: "posts")
    }
    
    var numberOfFollowing: NSAttributedString{
        return attrStatText(value: user.stats?.following ?? 0, label: "following")
    }
    
    private func attrStatText(value:Int, label: String)-> NSAttributedString{
        let atttributedTxt = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        atttributedTxt.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.label]))
        return atttributedTxt
    }
}
