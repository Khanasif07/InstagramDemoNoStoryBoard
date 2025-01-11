//
//  CommentViewModel.swift
//  InstagramDemo
//
//  Created by Asif Khan on 13/12/2024.
//

import Foundation
import UIKit
struct CommentViewModel{
    private let comment: Comment
    init(comment: Comment) {
        self.comment = comment
    }
    
    var profileImageUrl: URL?{
        return URL(string: comment.profileImageUrl)
    }
    
    var username: String{
        return comment.username
    }
    
    func configureCommentText() -> NSAttributedString{
        let attString = NSMutableAttributedString(string: "\(username) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14) ,.foregroundColor: UIColor.black])
        
        attString.append(NSAttributedString(string: comment.commentText,attributes: [.font: UIFont.systemFont(ofSize: 14) ,.foregroundColor: UIColor.black]))
        
        return attString
    }
    
    func size(forWidth width: CGFloat) -> CGSize{
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
