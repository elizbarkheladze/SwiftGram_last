//
//  ProfileCellViewModel.swift
//  SwiftaGram
//
//  Created by alta on 9/8/22.
//

import Foundation

struct ProfileCellViewModel{
    private let user: User
    var profileImageUrl : URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        return user.username
    }
    
    var name: String {
        return user.name
    }
    
    init(user: User) {
        self.user = user
    }
}
