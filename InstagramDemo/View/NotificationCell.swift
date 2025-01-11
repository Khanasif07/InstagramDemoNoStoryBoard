//
//  NotificationCell.swift
//  InstagramDemo
//
//  Created by Asif Khan on 14/12/2024.
//

import UIKit
protocol NotificationCellDelegate: NSObject{
    func cell(_ cell: NotificationCell,wantsToFollow uid: String)
    func cell(_ cell: NotificationCell,wantsToUnFollow uid: String)
    func cell(_ cell: NotificationCell,wantsViewPost postId: String)
}
class NotificationCell: UITableViewCell {
    // MARK: - Properties
    weak var delegate: NotificationCellDelegate?
    var viewModel: NotificationViewModel?{
        didSet{
            configureUI()
        }
    }
    
 
    private lazy var profileImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 0.5
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - IBActions
    @objc func handleFollowTapped(){
        guard let viewModel = viewModel else { return }
        if viewModel.notification.userIsFollowed{
            self.delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }else{
            self.delegate?.cell(self, wantsToUnFollow: viewModel.notification.uid)
        }
    }
    
    @objc func handlePostTapped(){
        guard let viewModel = viewModel else { return }
        self.delegate?.cell(self, wantsViewPost: viewModel.notification.postId)
    }
    
    @objc func handleProfileImageTapped(){
        
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    // MARK: - Helper
    func setupViews(){
        contentView.addSubview(profileImgView)
        profileImgView.setDimensions(height: 40, width: 40)
        profileImgView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 8)
        profileImgView.layer.cornerRadius = 20
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor,paddingRight: 12,width: 88, height: 32)
        
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor,paddingRight: 12,width: 40, height: 40)
        
        contentView.addSubview(notificationLabel)
        notificationLabel.centerY(inView: profileImgView,leftAnchor: profileImgView.rightAnchor,paddingLeft: 4)
        notificationLabel.anchor(right: followButton.leftAnchor,paddingRight: 4)
    }
    func configureUI(){
        guard let viewModel = viewModel else { return }
        profileImgView.sd_setImage(with: viewModel.profileImgUrl)
        notificationLabel.attributedText = viewModel.notificationMessage
        followButton.isHidden = viewModel.shouldHideFollowButton
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        postImageView.isHidden = viewModel.shouldHidePostImage
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBGColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
}
