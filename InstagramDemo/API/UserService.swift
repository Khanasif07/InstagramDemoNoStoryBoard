//
//  UserService.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import Foundation
import FirebaseAuth
typealias firestoreCompletion = (Error?) -> Void
struct UserService{
    static func fetchUser(withUid uid: String,completion: @escaping(User)-> Void){
        Collection_Users.document(uid).getDocument { snapshot, error in
            print("Debug: Snapshot is \(String(describing: snapshot?.data()))")
            guard let dictionary = snapshot?.data() else { return }
            let user  = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User])-> Void){
        Collection_Users.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.map { queryDocumentSnapshot in
                return User(dictionary: queryDocumentSnapshot.data())
            }
            completion(users)
        }
    }
    
    static func followUser(uid: String, completion:@escaping(firestoreCompletion)){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Collection_Following.document(currentUid).collection("user-following").document(uid).setData([:]){
            error in
            Collection_Followers.document(uid).collection("user-followers").document(currentUid).setData([:]) {  error in
                completion(error)
            }
        }
    }
    
    static func unFollowUser(uid: String, completion:@escaping(firestoreCompletion)){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Collection_Following.document(currentUid).collection("user-following").document(uid).delete(){
            error in
            Collection_Followers.document(uid).collection("user-followers").document(currentUid).delete() {  error in
                completion(error)
            }
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool)->Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Collection_Following.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot,error) in
            guard let isfollowed = snapshot?.exists else { return }
            completion(isfollowed)
        }
    }
    
    static func fetechUserStats(uid: String, completion: @escaping(UserStats)->Void){
        Collection_Followers.document(uid).collection("user-followers").getDocuments { (snapshot,error) in
            let followers = snapshot?.documents.count ?? 0
            Collection_Following.document(uid).collection("user-following").getDocuments { (snapshot,error) in
                let following = snapshot?.documents.count ?? 0
                Collection_Posts.whereField("ownerUid", isEqualTo: uid).getDocuments { (snapshot, error) in
                    let posts = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, following: following,posts: posts))
                }
            }
        }
    }
}
