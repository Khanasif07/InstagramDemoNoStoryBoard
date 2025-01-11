//
//  UploadPostController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 13/12/2024.
//

import UIKit
protocol UploadPostControllerDelegate: AnyObject{
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}
class UploadPostController: UIViewController {
    // MARK: - Properties
    var selectedImage: UIImage?{
        didSet{
            photoImageView.image = selectedImage
        }
    }
    var currentUser: User?
    weak var delegate: UploadPostControllerDelegate?
    
    private let photoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "venom-7")
        return iv
    }()
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeHolderText = "Enter caption.."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        tv.placeholderShouldInCenter = false
        return tv
    }()
    
    private let charCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/100"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - API
    
    
    // MARK: - Helper
    private func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 12,paddingRight: 12,height: 64)
        
        view.addSubview(charCountLabel)
        charCountLabel.anchor(top: captionTextView.bottomAnchor,right: view.rightAnchor,paddingRight: 12)
    }
    
    func checkMaxLength(_ textVuew: UITextView, maxLenghth: Int){
        if (textVuew.text.count) > maxLenghth{
            textVuew.deleteBackward()
        }
    }
    
    // MARK: - IBActions
    @objc func didTapDone(){
        guard let image = selectedImage else { return}
        guard let caption = captionTextView.text else { return }
        showLoader(true)
        PostService.uploadPost(caption: caption, image: image,user: self.currentUser!) { error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.showLoader(false)
            })
            if let err = error{
                print(err)
                return
            }
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    @objc func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate
extension UploadPostController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView, maxLenghth: 100)
        let count = textView.text.count
        charCountLabel.text = "\(count)/100"
    }
}
