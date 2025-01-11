//
//  CommentService.swift
//  InstagramDemo
//
//  Created by Asif Khan on 13/12/2024.
//

import Foundation
import Firebase
class CommentService{
    static func uploadComment(comment: String, postId: String, user: User,completion: @escaping(firestoreCompletion)){
        let data: [String:Any] = ["uid": user.uid ?? "", "comment": comment,"username": user.username ?? "","profileImageUrl": user.profileImageUrl ?? "","timestamp": Timestamp(date: Date())]
        
        Collection_Posts.document(postId).collection("comments").addDocument(data: data, completion: completion)

    }
    
    static func fetchComments(forPost postId: String, completion: @escaping([Comment])->Void){
        var comments = [Comment]()
        let query = Collection_Posts.document(postId).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added{
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        }
        
    }
}
