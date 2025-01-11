//
//  InputTextView.swift
//  InstagramDemo
//
//  Created by Asif Khan on 13/12/2024.
//

import UIKit

class InputTextView: UITextView {

    // MARK: - Properties
    
    var placeHolderText: String?{
        didSet{
            placeholderLabel.text = placeHolderText
        }
    }
    var placeholderShouldInCenter: Bool = true{
        didSet{
            if placeholderShouldInCenter{
                placeholderLabel.anchor(left: leftAnchor,right: rightAnchor,paddingLeft: 8)
                placeholderLabel.centerY(inView: self)
            }else{
                placeholderLabel.anchor(top: topAnchor,left: leftAnchor,paddingTop: 6,paddingLeft: 8)
            }
        }
    }
     let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame,textContainer: textContainer)
       
        addSubview(placeholderLabel)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    // MARK: - IBActions
    
    @objc func handleTextDidChange(){
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    // MARK: - Properties
    
    func checkMaxLength(_ textVuew: UITextView, maxLenghth: Int){
        if (textVuew.text.count) > maxLenghth{
            textVuew.deleteBackward()
        }
        
    }

}
