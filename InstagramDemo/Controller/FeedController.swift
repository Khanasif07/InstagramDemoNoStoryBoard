//
//  FeedController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit
import FirebaseAuth
class FeedController: UIViewController {
    
    // MARK: - Properties
    let tableView = UITableView()
    private var posts:[Post] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var post:Post?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fecthPosts()
        
        if post != nil{
            checkIfUserLikedPost()
        }
    }
    
    // MARK: - API
    private func fecthPosts(){
        guard  post == nil else {return}
        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPost()
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
        //        PostService.fetchPosts({ posts in
        //            print(posts)
        //            self.posts = posts
        //            self.checkIfUserLikedPost()
        //            DispatchQueue.main.async {
        //                self.tableView.refreshControl?.endRefreshing()
        //                self.tableView.reloadData()
        //            }
        //        })
    }
    
    private func checkIfUserLikedPost(){
        if let post = post {
            PostService.checkIfUserLikedPost(post: post) { didlike in
                self.post?.didLike = didlike
            }
        }else{
            self.posts.forEach { post in
                PostService.checkIfUserLikedPost(post: post) { didlike in
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId}){
                        self.posts[index].didLike = didlike
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - IBActions
    @objc func handleRefresh(){
        fecthPosts()
    }
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
            let controller = LoginViewController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }catch {
            print("failed to signout")
        }
    }
    
    // MARK: - Helper
    
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400 // Provide an estimated height
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        navigationItem.title = "Feed"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
}

//MARK: - UITableviewDataSource
extension FeedController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post == nil ?  self.posts.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else { return UITableViewCell()}
        cell.delegate = self
        if let post = post{
            cell.viewModel = PostViewModel(post: post)
        }else{
            cell.viewModel = PostViewModel(post: self.posts[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - FeedCellDelegate
extension FeedController: FeedCellDelegate{
    func cell(_ cell: FeedCell, wantsToShowprofile uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentForPost post: Post) {
        let controller = CommentController(post: post)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLikePost post: Post) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        cell.viewModel?.post.didLike.toggle()
        if post.didLike{
            print("Unlike")
            PostService.unlikePost(forPost: post, completion: { error in
                if let err = error{
                    print(err)
                    return
                }
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
                if let index = self.posts.firstIndex(where: {$0.postId == post.postId}){
                    self.posts[index].didLike = false
                    self.posts[index].likes =  cell.viewModel?.post.likes ?? 0
                }
            })
        }else{
            print("like the post")
            PostService.likePost(forPost: post, completion: { error in
                if let err = error{
                    print(err)
                    return
                }
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                if let index = self.posts.firstIndex(where: {$0.postId == post.postId}){
                    self.posts[index].didLike = true
                    self.posts[index].likes =  cell.viewModel?.post.likes ?? 0
                }
                //
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            })
        }
    }
}
