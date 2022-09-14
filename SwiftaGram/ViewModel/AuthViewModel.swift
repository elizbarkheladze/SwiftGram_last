//
//  AuthViewModel.swift
//  SwiftaGram
//
//  Created by alta on 9/6/22.
//

import UIKit

protocol formViewModel {
    func updateForm()
}


protocol AuthViewModel {
    var isValid: Bool{ get }
    var btnColor: UIColor { get }
    var btnTitleColor: UIColor { get }
}

struct LogInViewModel : AuthViewModel {
    var email: String?
    var password: String?
    
    var isValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var btnColor : UIColor {
        return isValid ? .cyan : .cyan.withAlphaComponent(0.5)
    }
    
    var btnTitleColor: UIColor {
        return isValid ? .white : .gray
    }
}

struct RegistrationViewModel : AuthViewModel{
    var email: String?
    var password: String?
    var name: String?
    var username: String?
    
    var isValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false &&
        name?.isEmpty == false && username?.isEmpty == false
    }
    
    var btnColor: UIColor  {
        return isValid ? .cyan : .cyan.withAlphaComponent(0.5)
    }
    
    var btnTitleColor: UIColor  {
        return isValid ? .white : .gray
    }
    
}
