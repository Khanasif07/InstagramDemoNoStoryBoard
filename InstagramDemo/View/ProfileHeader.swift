//
//  ProfileHeader.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit
import SDWebImage
protocol ProfileHeaderDelegate: class{
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor : User)
}
class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties
    var viewModel: ProfileHeaderViewModel?{
        didSet{
            configure()
        }
    }
    weak var delegate:ProfileHeaderDelegate?
    
    private let profileImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jhon abrahim"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didtapEditProfile), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attrStatText(value: 1, label: "posts")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attrStatText(value: 1, label: "followers")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attrStatText(value: 100, label: "following")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = .black
        return button
    }()
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImgView)
        profileImgView.anchor(top: topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 12)
        profileImgView.setDimensions(height: 80, width: 80)
        profileImgView.layer.cornerRadius = 40
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImgView.bottomAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 12)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: nameLabel.bottomAnchor,left:leftAnchor,right: rightAnchor,paddingTop: 16, paddingLeft: 24,paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
        addSubview(stack)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.centerY(inView: profileImgView)
        stack.anchor(left: profileImgView.rightAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 12,height: 50)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        addSubview(buttonStack)
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.anchor(left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 50)
        topDivider.anchor(top: buttonStack.topAnchor,left: leftAnchor,right: rightAnchor,height: 0.5)
        bottomDivider.anchor(top: buttonStack.bottomAnchor,left: leftAnchor,right: rightAnchor,height: 0.5)


    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    // MARK: - IBActions
    @objc func didtapEditProfile(){
        self.delegate?.header(self, didTapActionButtonFor: viewModel!.user)
    }
    
    // MARK: - Helper
    private func configure(){
        nameLabel.text = self.viewModel?.fullname
        editProfileButton.setTitle(viewModel?.followButtonText, for: .normal)
        editProfileButton.setTitleColor(viewModel?.followButtonTextColor, for: .normal)
        editProfileButton.backgroundColor = viewModel?.followButtonBackgroundColor
        profileImgView.sd_setImage(with: self.viewModel?.profileImageUrl)
        postLabel.attributedText = self.viewModel?.numberOfPosts
        followersLabel.attributedText = self.viewModel?.numberOfFollowers
        followingLabel.attributedText = self.viewModel?.numberOfFollowing
    }
    
    private func attrStatText(value:Int, label: String)-> NSAttributedString{
        let atttributedTxt = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        atttributedTxt.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.label]))
        return atttributedTxt
    }
}
