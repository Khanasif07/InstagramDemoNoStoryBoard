//
//  SearchController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit
private let cellIdenitfier = "UserCell"
class SearchController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView()
    private var users: [User] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private var posts:[Post] = []
    private var filteredUsers: [User] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
        return cv
    }()
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureUI()
        fetchUsers()
        fetchPosts()
    }
    
    // MARK: - API
    private func fetchUsers(){
        UserService.fetchUsers { users in
                self.users = users
        }
    }
    
    private func fetchPosts(){
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helper
    
    func configureUI(){
        navigationItem.title = "Explore"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: cellIdenitfier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.fillSuperview()
        tableView.isHidden = true
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }

    private func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }

}

// MARK: - UISearchBarDelegate
extension SearchController:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        collectionView.isHidden = false
        tableView.isHidden = true
    }
}

// MARK: - Tableview delegate
extension SearchController: UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : self.users.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenitfier, for: indexPath) as? UserCell else { return UITableViewCell()}
        cell.viewModel = UserCellViewModel(user:  inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row])
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProfileController(user: inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - UISearchResultsUpdating
extension SearchController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTxt = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({ $0.username?.contains(searchTxt) ?? false || $0.fullname?.contains(searchTxt) ?? false})
        print(searchTxt)
        self.tableView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource and delegate
extension SearchController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else { return UICollectionViewCell()}
        cell.viewModel = PostViewModel(post: self.posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController()
        controller.post = self.posts[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchController: UICollectionViewDelegateFlowLayout{
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
}
