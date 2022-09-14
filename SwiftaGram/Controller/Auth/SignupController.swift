//
//  SignupController.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit

class SignupController: UIViewController {
    
    
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profilePhoto: UIImage?
    weak var delegate : AuthDelegate?
    private let uploadImageBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(photoSelectionHnadler), for: .touchUpInside)
        return button
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
    private let nameTXTField  = CustomTXTFIeld(placeholder: "Name")
    private let usernameTXTFIeld  = CustomTXTFIeld(placeholder: "Username")
    
    private let signUpBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .cyan.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(signupHandler), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let userHasAccout: UIButton = {
        let button = UIButton(type: .system)
        button.attedTitle(left: "oh, alredy have an account ?", right: "Log in her then")
        button.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotObservers()
    }
    
    //MARK: - Action
    @objc func goToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTxtField {
            viewModel.email = sender.text
        } else if sender == passwordTxtField{
            viewModel.password = sender.text
        } else if sender == nameTXTField{
            viewModel.name = sender.text
        }else  {
            viewModel.username = sender.text
        }
        updateForm()
    }
    
    @objc func photoSelectionHnadler(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    
    @objc func signupHandler() {
        guard let email = emailTxtField.text else  { return }
        guard let password = passwordTxtField.text else  { return }
        guard let name = nameTXTField.text else  { return }
        guard let username = usernameTXTFIeld.text?.lowercased() else  { return }
        guard let profileImage = profilePhoto else {return }

        let userInfo = AuthInfo(email: email, password: password, name: name,
                                username: username, profileImage: profileImage)
        
        AutService.registerUser(userinfo: userInfo) { error in
            if let error = error {
                print("erorr : \(error.localizedDescription)")
            }
            
            self.delegate?.authWasComplete()
        }
    }
    
   //MARK: - Helpers
    func configureUI() {
        getGradient()
        
        view.addSubview(uploadImageBtn)
        uploadImageBtn.centerX(inView: view)
        uploadImageBtn.setDimensions(height: 140, width: 140)
        uploadImageBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTxtField,passwordTxtField,nameTXTField,usernameTXTFIeld,signUpBtn])
        stack.axis = .vertical
        stack.spacing = 20
        
        
        view.addSubview(stack)
        stack.anchor(top:uploadImageBtn.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        view.addSubview(userHasAccout)
        userHasAccout.centerX(inView: view)
        userHasAccout.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    func configureNotObservers() {
        emailTxtField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTxtField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        nameTXTField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTXTFIeld.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}


extension SignupController: formViewModel {
    func updateForm() {
        signUpBtn.backgroundColor = viewModel.btnColor
        signUpBtn.setTitleColor(viewModel.btnTitleColor, for: .normal)
        signUpBtn.isEnabled = viewModel.isValid
    }
    
    
}

//MARK: - UIImagePickerControllerDelegate
extension SignupController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profilePhoto = image
        
        
        uploadImageBtn.layer.cornerRadius = uploadImageBtn.frame.width / 2
        uploadImageBtn.layer.masksToBounds = true
        uploadImageBtn.layer.borderColor = UIColor.white.cgColor
        uploadImageBtn.layer.borderWidth = 2
        uploadImageBtn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true,completion: nil)
    }
}
