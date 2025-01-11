//
//  PostViewModel.swift
//  InstagramDemo
//
//  Created by Asif Khan on 13/12/2024.
//

import Foundation
import UIKit
struct PostViewModel{
    var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var imageUrl: URL?{
        return URL(string: post.imageUrl)
    }
    
    var userImageUrl: URL?{
        return URL(string: post.ownerImageUrl)
    }
    
    var username: String{
        return post.ownerUsername
    }
    
    var caption: String{
        return post.caption
    }
    
    var likes: Int{
        return post.likes
    }
    
    var likesLabelText: String{
        if post.likes != 1{
            return "\(post.likes) likes"
        }else{
            return "\(post.likes) like"
        }
    }
    
    var likeButtonTintColor: UIColor{
        return post.didLike ? UIColor.red : UIColor.black
    }
    
    var likeButtonImage: UIImage{
        return post.didLike ? UIImage(named: "like_selected")! : UIImage(named: "like_unselected")!
    }
    
    func timeAgo() -> String {
        // Convert timestamp to Date
        let date = post.timestamp.dateValue()
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full // Options: .full, .short, .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
