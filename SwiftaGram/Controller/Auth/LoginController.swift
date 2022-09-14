//
//  LoginController.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit

protocol AuthDelegate : AnyObject {
    func authWasComplete()
}

class LoginController: UIViewController {
    
    
    //MARK: - Properties
    
    private var viewModel = LogInViewModel()
    weak var delegate : AuthDelegate?
    private let logoImage : UIImageView = {
        let imageView = UIImageView(image : UIImage(imageLiteralResourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let emailTxtField: CustomTXTFIeld = {
        let textField =  CustomTXTFIeld(placeholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    private let passwordTxtField: CustomTXTFIeld = {
        let textField =  CustomTXTFIeld(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    private let loginBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .cyan.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(logUserIn), for: .touchUpInside)
        return button
    }()
    
    private let passwordRecoverieBtn: UIButton = {
        let button = UIButton(type: .system)
        button.attedTitle(left: "Did you forgot password ?", right: "Recover it Here")
        return button
    }()
    
    private let signUpBtn: UIButton = {
        let button = UIButton(type: .system)
        button.attedTitle(left: "Dont hava an Account ?", right: "Sign up here ")
        button.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotObservers()
        
    }
    //MARK: - Actions
    
    @objc func logUserIn(){
        guard let email = emailTxtField.text else  { return }
        guard let password = passwordTxtField.text else  { return }
        
        AutService.logUserIn(email: email, password: password) { (result, error) in
            if let error = error {
                print("erorr : \(error.localizedDescription)")
                return
            }
            self.delegate?.authWasComplete()
            
        }
    }
    
    @objc func goToSignUp() {
        let vc = SignupController()
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTxtField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        getGradient()
        navigationController?.navigationBar.isHidden = true
        
        navigationController?.navigationBar.barStyle = .black
        
        
        
        view.addSubview(logoImage)
        logoImage.centerX(inView: view)
        logoImage.setDimensions(height: 80, width: 120)
        logoImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         paddingTop: 32)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTxtField,passwordTxtField,loginBtn,passwordRecoverieBtn])
        stack.axis = .vertical
        stack.spacing = 20
        
        
        view.addSubview(stack)
        stack.anchor(top:logoImage.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        view.addSubview(signUpBtn)
        signUpBtn.centerX(inView: view)
        signUpBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    func configureNotObservers() {
        emailTxtField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTxtField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}
//MARK: - FormViewModel
extension LoginController: formViewModel {
    func updateForm() {
        loginBtn.backgroundColor = viewModel.btnColor
        loginBtn.setTitleColor(viewModel.btnTitleColor, for: .normal)
        loginBtn.isEnabled = viewModel.isValid
    }
    
    
}
