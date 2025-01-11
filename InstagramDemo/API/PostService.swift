//
//  PostService.swift
//  InstagramDemo
//
//  Created by Asif Khan on 13/12/2024.
//

import Foundation
import Firebase
import FirebaseAuth
struct PostService{
    
    static func uploadPost(caption: String, image: UIImage,user: User, completion: @escaping(firestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else{ return}
        let imageUrl = "https://i.pravatar.cc/300".replaceLastThreeCharactersWithRandomNumbers()
//        ImageUploader.uploadImage(image: image) { imageUrl in
        let data = ["caption": caption, "imageUrl": imageUrl, "timestamp": Timestamp(date: Date()),"likes": 0,"ownerUid": uid,"ownerImageUrl": user.profileImageUrl ?? "","ownerUsername": user.username ?? ""] as? [String:Any]
            Collection_Posts.addDocument(data: data!, completion: completion)
            
//        }
    }
    
    static func fetchPosts(_ completion: @escaping([Post])->Void){
        Collection_Posts.order(by: "timestamp", descending: true).getDocuments { (snapshot,error) in
            guard let documents = snapshot?.documents else { return}
        
            let posts = documents.map({ Post(dictionary: $0.data(), postId: $0.documentID)})
            completion(posts)
        }
    }
    
    static func fetchPost(withPostId postId:String,_ completion: @escaping(Post)->Void){
        Collection_Posts.document(postId).getDocument { (snapshot,error) in
            guard let snapshot = snapshot else { return}
        
            let post = Post(dictionary: snapshot.data()!, postId: snapshot.documentID)
            completion(post)
        }
    }
    
    
    static func fetchPosts(forUser uid: String,_ completion: @escaping([Post])->Void){
        let query = Collection_Posts
//            .order(by: "timestamp", descending: true)
            .whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { (snapshot,error) in
            guard let documents = snapshot?.documents else { return}
        
            let posts = documents.map({ Post(dictionary: $0.data(), postId: $0.documentID)})
            completion(posts)
        }
    }
    
    static func likePost(forPost post: Post, completion: @escaping(firestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Collection_Posts.document(post.postId).updateData(["likes": post.likes + 1])
        
        Collection_Posts.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            Collection_Users.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(forPost post: Post, completion: @escaping(firestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else {return}
        Collection_Posts.document(post.postId).updateData(["likes": post.likes - 1])
        
        Collection_Posts.document(post.postId).collection("post-likes").document(uid).delete(completion: { _ in
            Collection_Users.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        })
            
    }
    
    static func checkIfUserLikedPost(post : Post, completion: @escaping(Bool)->Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Collection_Users.document(uid).collection("user-likes").document(post.postId).getDocument { (snapshot,error) in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    static func fetchFeedPosts(completion: @escaping([Post])->Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts: [Post] = []
        
        Collection_Users.document(uid).collection("user-feed").getDocuments{  (snapshot,error) in
            snapshot?.documents.forEach({ document in
                fetchPost(withPostId: document.documentID) { post in
                    posts.append(post)
                    if posts.count == snapshot?.documents.count ?? 0 {
                        posts.sort(by: {$0.timestamp.seconds > $1.timestamp.seconds})
                        completion(posts)
                    }
                }
            })
        }
                                                                            
    }
    
    static func updateUserFeedAfterFollowing(user: User, didFollow: Bool){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = Collection_Posts.whereField("ownerUid", isEqualTo: user.uid ?? "")
        query.getDocuments { (snapshot,error) in
            guard let docs = snapshot?.documents else { return }
            let docsIds = docs.map({$0.documentID})
            print(docsIds)
            
            docsIds.forEach { docId in
                if didFollow{
                    Collection_Users.document(uid).collection("user-feed").document(docId).setData([:])
                }else{
                    Collection_Users.document(uid).collection("user-feed").document(docId).delete()
                }
               
            }
            
        }
    }
}

