//
//  AuthenticationViewModel.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import UIKit
protocol AuthenticationViewModel{
    var formIsValid:Bool{ get}
    var buttonBackgroundColor: UIColor{ get }
    var buttonTitleColor: UIColor{ get }
}
struct LoginViewModel: AuthenticationViewModel{
    var email: String?
    var password: String?
    
    var formIsValid: Bool{
        return email?.isEmpty  == false && password?.isEmpty  == false
    }
    
    var buttonBackgroundColor: UIColor{
        return formIsValid ? UIColor.systemPurple : UIColor.systemPurple.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor{
        return formIsValid ? UIColor.white : UIColor.white.withAlphaComponent(0.5)
    }
}


struct RegistrationViewModel: AuthenticationViewModel{
    var email: String?
    var password: String?
    var fullName: String?
    var userName: String?
    
    var formIsValid: Bool{
        return email?.isEmpty  == false && password?.isEmpty  == false && fullName?.isEmpty  == false && userName?.isEmpty  == false
    }
    
    var buttonBackgroundColor: UIColor{
        return formIsValid ? UIColor.systemPurple : UIColor.systemPurple.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor{
        return formIsValid ? UIColor.white : UIColor.white.withAlphaComponent(0.5)
    }
}
