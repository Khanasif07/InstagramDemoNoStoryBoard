//
//  CommentCell.swift
//  InstagramDemo
//
//  Created by Asif Khan on 13/12/2024.
//

import Foundation
import UIKit
class CommentCell: UICollectionViewCell {
    // MARK: - Properties
    
    var viewModel: CommentViewModel?{
        didSet{
            configureUI()
        }
    }
    
    private let profileImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImgView)
        profileImgView.setDimensions(height: 40, width: 40)
        profileImgView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 8)
        profileImgView.layer.cornerRadius = 20
        
        commentLabel.numberOfLines = 0
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImgView,leftAnchor: profileImgView.rightAnchor,paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor,paddingRight: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    // MARK: - Helper
    
    func configureUI(){
        profileImgView.sd_setImage(with: self.viewModel?.profileImageUrl)
        commentLabel.attributedText = viewModel?.configureCommentText()
    }
}
