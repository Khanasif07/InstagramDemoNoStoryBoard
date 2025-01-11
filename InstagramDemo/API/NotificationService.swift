//
//  NotificationService.swift
//  InstagramDemo
//
//  Created by Asif Khan on 14/12/2024.
//

import Firebase
import FirebaseAuth
struct NotificationService {
    static func uploadNotification(toUid uid: String,fromUser: User ,type: NotificationType,post : Post? = nil){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let docRef = Collection_Notifications.document(uid).collection("user-notifications").document()
        
        var data = [ "timestamp": Timestamp(date: Date()),"uid": fromUser.uid ?? "","type": type.rawValue,"id": docRef.documentID,"userProfileImgUrl": fromUser.profileImageUrl ?? "","username": fromUser.username ?? "",] as? [String:Any]
        
        if let post = post{
            data?["postId"] = post.postId
            data?["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data!)
    }
    
    static func fetchNotifications(completion: @escaping([Notification])-> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = Collection_Notifications.document(currentUid).collection("user-notifications").order(by: "timestamp", descending: true)
        
        query.getDocuments { (snapshot,error) in
            guard let docs = snapshot?.documents else { return }
            
            let notifications  = docs.map({ Notification(dictionary: $0.data())})
            completion(notifications)
        }
    }
    
}
