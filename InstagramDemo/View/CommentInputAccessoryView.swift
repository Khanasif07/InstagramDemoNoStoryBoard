//
//  CommentInputAccessoryView.swift
//  InstagramDemo
//
//  Created by Asif Khan on 13/12/2024.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: NSObject{
    func inputView(_ inputview: CommentInputAccessoryView, wantsToUploadComment comment: String)
}
class CommentInputAccessoryView: UIView{
    // MARK: - Properties
    weak var delegate: CommentInputAccessoryViewDelegate?
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeHolderText = "Enter comment.."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeholderShouldInCenter = true
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(handleCommentUpload), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        addSubview(postButton)
        postButton.anchor(top: topAnchor,right: rightAnchor,paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor,left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right: postButton.leftAnchor,paddingTop: 8,paddingLeft: 8,paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        addSubview(divider)
        divider.backgroundColor = .lightGray
        divider.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor,height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    // MARK: - Helpers
    func clearCommentTextView(){
        commentTextView.text = ""
        commentTextView.placeholderLabel.isHidden = false
    }
    
    // MARK: - IBActions
    @objc func handleCommentUpload(){
        self.delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    
}
