//
//  ProfileController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit
private let cellIdenitifier = "ProfileCell"
private let headerIdenitifier = "ProfileHeader"
class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    var group = DispatchGroup()
    private var user: User
    private var posts: [Post] = []
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        hitApi()
    }
    
    // MARK: - API
    func hitApi(){
        showLoader(true)
        group.enter()
        checkIfUserIsFollowed {
            self.group.leave()
        }
        group.enter()
        fetchUserStats {
            self.group.leave()
        }
        group.enter()
        fetchUserPosts {
            self.group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            self.showLoader(false)
        }
    }
    
    private func checkIfUserIsFollowed(completion: @escaping()-> Void){
        UserService.checkIfUserIsFollowed(uid: user.uid ?? "") { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
            completion()
        }
    }
    
    private func fetchUserStats(completion: @escaping()-> Void){
        UserService.fetechUserStats(uid: user.uid ?? "") { userStats in
            self.user.stats = userStats
            self.collectionView.reloadData()
            completion()
        }
    }
    
    private func fetchUserPosts(completion: @escaping()-> Void){
        PostService.fetchPosts(forUser: user.uid ?? "") { posts in
            self.posts = posts
            self.collectionView.reloadData()
            completion()
        }
    }
    
    // MARK: - Helper
    private func configureCollectionView(){
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdenitifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdenitifier)
    }
}

// MARK: - CollectionViewDataSource
extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdenitifier, for: indexPath) as? ProfileCell else { return UICollectionViewCell()}
        cell.viewModel = PostViewModel(post: self.posts[indexPath.row])
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdenitifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        return header
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate{
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor: User) {
        
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        if user.isCurrentUser{
            print("show edit profile")
        }else if user.isFollowed{
//            print("show unfollow user here")
            UserService.unFollowUser(uid: user.uid ?? "") { error in
                print("Did un follow user update ui now..")
                self.user.isFollowed = false
                self.collectionView.reloadData()
                //
                PostService.updateUserFeedAfterFollowing(user: self.user, didFollow: false)
            }
        }else{
//            print("show FOLLOW user here")
            UserService.followUser(uid: user.uid ?? "") { error in
                print("Did follow user update ui now..")
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
            
            NotificationService.uploadNotification(toUid: user.uid ?? "", fromUser: currentUser, type: .follow)
            
            PostService.updateUserFeedAfterFollowing(user: user, didFollow: true)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController()
        controller.post = self.posts[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
