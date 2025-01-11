//
//  FeedCell.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit
protocol FeedCellDelegate: NSObject{
    func cell(_ cell: FeedCell, wantsToShowCommentForPost post: Post)
    func cell(_ cell: FeedCell, didLikePost post: Post)
    func cell(_ cell: FeedCell, wantsToShowprofile uid: String)
}
//class FeedCell: UITableViewCell {
//    //MARK: - Properties
//    var viewModel: PostViewModel?{
//        didSet{
//            configure()
//        }
//    }
//    weak var delegate: FeedCellDelegate?
//    private var stackView = UIStackView()
//    
//    private lazy var userNameButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("venom", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(didtapeUserName), for: .touchUpInside)
//        return button
//    }()
//    
//     lazy var likeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
//        return button
//    }()
//    
//    private lazy var commentButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "comment"), for: .normal)
//        button.tintColor = .black
//        button.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
//        return button
//    }()
//    
//    private lazy var shareButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "send2"), for: .normal)
//        button.tintColor = .black
//        return button
//    }()
//    
//    private lazy var likesLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 13)
//        return label
//    }()
//    
//    private lazy var captionLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.font = UIFont.boldSystemFont(ofSize: 13)
//        return label
//    }()
//    
//    private lazy var postTimeLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .gray
//        label.font = UIFont.boldSystemFont(ofSize: 12)
//        return label
//    }()
//    
//    private lazy var postImageView: UIImageView = {
//        let imageView = UIImageView()
////        imageView.image = UIImage(named: "venom-7")
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
////        imageView.backgroundColor = .systemPurple
//        return imageView
//    }()
//    
//    private lazy var profileImageView: UIImageView = {
//        let imageView = UIImageView()
////        imageView.image = UIImage(named: "venom-7")
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 20 // Circular
//        imageView.backgroundColor = .lightGray
//        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(tap)
//        return imageView
//    }()
//    // MARK: - Helpers
//   
//    // MARK: - view life cycle
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
////        self.backgroundColor = .yellow
////        contentView.backgroundColor = .red
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    //MARK: - IBActions
//    @objc func showUserProfile(){
//        guard let viewModel  = viewModel else { return }
//        self.delegate?.cell(self, wantsToShowprofile: viewModel.post.ownerUid)
//    }
//    
//    @objc func didTapComment(){
//        self.delegate?.cell(self, wantsToShowCommentForPost: self.viewModel!.post)
//    }
//    
//    @objc func didtapeUserName(){
//        guard let viewModel  = viewModel else { return }
//        self.delegate?.cell(self, wantsToShowprofile: viewModel.post.ownerUid)
//    }
//    
//    @objc func didTapLike(){
//        guard let viewModel  = viewModel else { return }
//        self.delegate?.cell(self, didLikePost: viewModel.post)
//    }
// 
//    private func setupViews() {
//      
//        contentView.addSubview(profileImageView)
//        profileImageView.anchor(top: contentView.topAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 12)
//        profileImageView.setDimensions(height: 40, width: 40)
//        
//        contentView.addSubview(userNameButton)
//        userNameButton.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 8)
//        
//        contentView.addSubview(postImageView)
//        postImageView.anchor(top: profileImageView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 8)
//        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
//       
//        configureActionButtons()
//        
//        contentView.addSubview(likesLabel)
//        likesLabel.anchor(top: stackView.bottomAnchor,left: leftAnchor,paddingTop: -4,paddingLeft: 8)
//        
//        contentView.addSubview(captionLabel)
//        captionLabel.anchor(top: likesLabel.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 8)
//
//        contentView.addSubview(postTimeLabel)
//        postTimeLabel.anchor(top: captionLabel.bottomAnchor,left: leftAnchor,bottom: contentView.bottomAnchor,paddingTop: 8,paddingLeft: 8,paddingBottom: 8)
//    }
//    
//    func configure(){
//        self.captionLabel.text = self.viewModel?.caption
//        self.likesLabel.text = self.viewModel?.likesLabelText
//        self.userNameButton.setTitle(viewModel?.username, for: .normal)
//        self.profileImageView.sd_setImage(with: self.viewModel?.userImageUrl)
//        self.postImageView.sd_setImage(with: self.viewModel?.imageUrl)
//        self.postTimeLabel.text = viewModel?.timeAgo()
//        self.likeButton.setImage(viewModel?.likeButtonImage, for: .normal)
//        self.likeButton.tintColor = viewModel?.likeButtonTintColor
//    }
//    
//    func configureActionButtons(){
//        stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        addSubview(stackView)
//        stackView.anchor(top: postImageView.bottomAnchor,width: 120,height: 50)
//    }
//}



class FeedCell: UITableViewCell {
    //
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var viewModel: PostViewModel?{
        didSet{
            configure()
        }
    }
    weak var delegate: FeedCellDelegate?
    //
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    private let  likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
        //setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(likesLabel)
        contentView.addSubview(captionLabel)
        contentView.addSubview(postTimeLabel)
        
        NSLayoutConstraint.activate([
            // Profile image and username
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            // Post image
            postImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 1), // Maintain aspect ratio
            
            //stackview
            stackView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 8),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Like
            likesLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            likesLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 8),
            
            // Caption
            captionLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8),
            captionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            //post
            postTimeLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8),
            postTimeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            postTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

        ])
    }
    
    func configure() {
        self.captionLabel.text = self.viewModel?.caption
        self.usernameLabel.text = viewModel?.username
        self.profileImageView.sd_setImage(with: self.viewModel?.userImageUrl)
        self.postImageView.sd_setImage(with: self.viewModel?.imageUrl)
        self.likesLabel.text = self.viewModel?.likesLabelText
        self.postTimeLabel.text = viewModel?.timeAgo()
        self.likeButton.setImage(viewModel?.likeButtonImage, for: .normal)
        self.likeButton.tintColor = viewModel?.likeButtonTintColor
    }
    
    @objc func showUserProfile(){
        guard let viewModel  = viewModel else { return }
        self.delegate?.cell(self, wantsToShowprofile: viewModel.post.ownerUid)
    }
    
    @objc func didTapComment(){
        self.delegate?.cell(self, wantsToShowCommentForPost: self.viewModel!.post)
    }
    
    @objc func didtapeUserName(){
        guard let viewModel  = viewModel else { return }
        self.delegate?.cell(self, wantsToShowprofile: viewModel.post.ownerUid)
    }
    
    @objc func didTapLike(){
        guard let viewModel  = viewModel else { return }
        self.delegate?.cell(self, didLikePost: viewModel.post)
    }
    
}
