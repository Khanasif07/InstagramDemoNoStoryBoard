//
//  UserCell.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit

class UserCell: UITableViewCell {
    // MARK: - Properties
    var viewModel: UserCellViewModel?{
        didSet{
            usernameLabel.text = viewModel?.username ?? ""
            fullnameLabel.text = viewModel?.fullname ?? ""
            profileImgView.sd_setImage(with: viewModel?.profileImageUrl)
        }
    }
    
    private let profileImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jhon_abrahim"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jhon abrahim"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - View Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper
    func setupViews(){
        addSubview(profileImgView)
        profileImgView.setDimensions(height: 48, width: 48)
        profileImgView.layer.cornerRadius = 24
        profileImgView.centerY(inView: self, leftAnchor: leftAnchor,paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        addSubview(stack)
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5.0
        stack.centerY(inView: profileImgView)
        stack.anchor(left: profileImgView.rightAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 12)
        
    }
}
