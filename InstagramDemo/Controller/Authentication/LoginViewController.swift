//
//  LoginViewController.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit
protocol AuthenticationDelegate: NSObject{
    func authenticationDidComplete()
}
class LoginViewController: UIViewController {

    // MARK: - Properties
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let imageIcon : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTxtFld: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTxtFld: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemPurple.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let doNotHaveAccountButton: UIButton = {
        let button  = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an acount? ", secondPart: "Sign up")
        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        return button
    }()
    
    private let forgetPasswordButton: UIButton = {
        let button  = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forget your paasword? ", secondPart: "Get help signing in.")
        return button
    }()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    // MARK: - IBActions
    @objc func handleShowSignup(){
        let controller  = RegistrationViewController()
        controller.delegate = delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(_ sender: UITextField){
        if sender == emailTxtFld{
            self.viewModel.email = sender.text
            print("Email:- \(String(describing: self.viewModel.email) )")
        }else if sender == passwordTxtFld{
            self.viewModel.password = sender.text
            print("Password:- \(String(describing: self.viewModel.password) )")
        }else{
            printContent("==")
        }
        loginButton.backgroundColor = self.viewModel.buttonBackgroundColor
        loginButton.isEnabled = self.viewModel.formIsValid
    }
    
    @objc func handleLogin(){
        guard let email = viewModel.email else { return }
        guard let password = viewModel.password else { return }
        AuthService.logUserIn(withEmail: email, password: password) { authDataResult in
            if authDataResult != nil {
                self.delegate?.authenticationDidComplete()
                //self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        self.view.backgroundColor = .purple
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        
        view.addSubview(imageIcon)
        imageIcon.centerX(inView: view)
        imageIcon.setDimensions(height: 80, width: 120)
        imageIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTxtFld,passwordTxtFld,loginButton,forgetPasswordButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: imageIcon.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(doNotHaveAccountButton)
        doNotHaveAccountButton.centerX(inView: view)
        doNotHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObserver(){
        emailTxtFld.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}
