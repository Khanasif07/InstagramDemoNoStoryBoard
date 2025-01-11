//
//  RegistrationViewController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit

class RegistrationViewController: UIViewController{

    // MARK: - Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private let plusProfileButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private let emailTxtFld: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let fullNameTxtFld: UITextField = {
        let tf = CustomTextField(placeholder: "FullName")
        return tf
    }()
    
    private let userNameTxtFld: UITextField = {
        let tf = CustomTextField(placeholder: "UserName")
        return tf
    }()
    
    private let passwordTxtFld: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signupButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button  = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an acount? ", secondPart: "Sign In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    // MARK: - IBActions
    @objc func handleShowLogin(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignup(){
        guard let email = viewModel.email else { return }
        guard let password = viewModel.password else { return }
        guard let fullName = viewModel.fullName else { return }
        guard let userName = viewModel.userName?.lowercased() else { return }
        guard let profileImage = self.profileImage  else { return }
        let authCred = AuthCredential(email: email, password: password, fullName: fullName, userName: userName, profileImage: profileImage)
        AuthService.registerUser(withCredential: authCred, { error in
            if let err = error{
                print(err)
                return
            }
            print("successfully registered user in firestore..")
            self.delegate?.authenticationDidComplete()
        })
    }
    
    @objc func textDidChange(_ sender: UITextField){
        switch sender{
        case emailTxtFld:
            self.viewModel.email = sender.text
        case passwordTxtFld:
            self.viewModel.password = sender.text
        case fullNameTxtFld:
            self.viewModel.fullName = sender.text
        case userNameTxtFld:
            self.viewModel.userName = sender.text
        default:
            printContent("==")
        }
        signupButton.backgroundColor = self.viewModel.buttonBackgroundColor
        signupButton.isEnabled = self.viewModel.formIsValid
        signupButton.titleLabel?.textColor = self.viewModel.buttonTitleColor
    }
    
    @objc func handleProfilePhotoSelect(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // MARK: - Helpers
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(plusProfileButton)
        plusProfileButton.centerX(inView: view)
        plusProfileButton.setDimensions(height: 140, width: 140)
        plusProfileButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTxtFld,passwordTxtFld,fullNameTxtFld,userNameTxtFld,signupButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: plusProfileButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObserver(){
        emailTxtFld.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTxtFld.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTxtFld.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

}

// MARK: - UIImagePickerControllerDelegate
extension RegistrationViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        plusProfileButton.layer.cornerRadius = plusProfileButton.frame.width/2
        plusProfileButton.layer.masksToBounds = true
        plusProfileButton.layer.borderColor = UIColor.white.cgColor
        plusProfileButton.layer.borderWidth = 2.0
        plusProfileButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true)
    }
    
}
