//
//  UserCellViewModel.swift
//  InstagramDemo
//
//  Created by Asif Khan on 12/12/2024.
//

import Foundation
struct UserCellViewModel{
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var profileImageUrl: URL?{
        return URL(string: user.profileImageUrl ?? "")!
    }
    
    var username:String{
        return user.username ?? ""
    }
    
    var fullname:String{
        return user.fullname ?? ""
    }
}
