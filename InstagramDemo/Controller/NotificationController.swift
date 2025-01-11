//
//  NotificationController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit

private let cellIdenitfier = "NotificationCell"
class NotificationController: UITableViewController {
    // MARK: - Properties
    private var notifications: [Notification] = []{
        didSet{
            tableView.reloadData()
        }
    }
   
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    // MARK: - API
    private func fetchNotifications(){
        NotificationService.fetchNotifications { notifications in
                self.notifications = notifications
            self.checkIfUserIsFollowed()
        }
    }
    
    @objc func handleRefresh(){
        fetchNotifications()
    }
    
    func checkIfUserIsFollowed(){
        notifications.forEach { notification in
            guard notification.type == .follow else { return }
            UserService.checkIfUserIsFollowed(uid: notification.uid, completion: { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id}){
                    self.notifications[index].userIsFollowed = isFollowed
                }
            })
        }
    }
    
    // MARK: - Helper
    private func configureTableView(){
        self.navigationItem.title = "Notifications"
        view.backgroundColor = .white
        tableView.register(NotificationCell.self, forCellReuseIdentifier: cellIdenitfier)
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }

}
// MARK: - Tableview delegate
extension NotificationController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenitfier, for: indexPath) as? NotificationCell else { return UITableViewCell()}
        cell.delegate = self
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        UserService.fetchUser(withUid: notifications[indexPath.row].uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
            self.showLoader(false)
        }
    }
}
// MARK: - NotificationCellDelegate
extension NotificationController: NotificationCellDelegate{
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        UserService.followUser(uid: uid, completion: { error in
            cell.viewModel?.notification.userIsFollowed.toggle()
            self.showLoader(false)
        })
    }
    func cell(_ cell: NotificationCell, wantsViewPost postId: String) {
        showLoader(true)
        PostService.fetchPost(withPostId: postId) { post in
            let controller = FeedController()
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
            self.showLoader(false)
        }
    }
    func cell(_ cell: NotificationCell, wantsToUnFollow uid: String) {
        showLoader(true)
        UserService.unFollowUser(uid: uid, completion: { error in
            cell.viewModel?.notification.userIsFollowed.toggle()
            self.showLoader(false)
        })
    }
}
