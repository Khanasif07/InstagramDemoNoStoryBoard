//
//  ProfileCell.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    // MARK: - Properties
    
    var viewModel: PostViewModel?{
        didSet{
            configureUI()
        }
    }
    
    private let postImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        
        addSubview(postImgView)
        postImgView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    // MARK: - Helper
    
    func configureUI(){
        postImgView.sd_setImage(with: self.viewModel?.imageUrl)
    }
}
