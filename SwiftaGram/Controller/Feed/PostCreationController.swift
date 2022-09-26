//
//  PostCreationController.swift
//  SwiftaGram
//
//  Created by alta on 9/8/22.
//

import Foundation
import UIKit


protocol PostCreationControllerDelegate : AnyObject {
    func userPublishedPost(_ controller: PostCreationController)
}

class PostCreationController : UIViewController {
    
    //MARK: - Properties
    
    var selectionImage : UIImage? {
        didSet{
            pictureImageView.image = selectionImage
        }
    }
    var user : User?
    
    weak var delegate : PostCreationControllerDelegate?
    
    private let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var postTxtContent : NewTextView = {
        let textView = NewTextView()
        textView.placeHolderText = "Enter Text ..."
        textView.backgroundColor = .gray
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.placeHolderCenter = false
        return textView
    }()
    
    private let wordsCountLbl : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    //MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfigutarion()
    }
    
    //MARK: - Actions
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func publisheTapped() {
        guard let image = selectionImage else { return }
        guard let textContent = postTxtContent.text else { return }
        guard let user = user else {
            return
        }

        showIndicator(true)
        UserPostService.publishPost(text: textContent, picture: image,user: user) {[weak self] error in
            self?.showIndicator(false)
            if let error = error {
                print("KAKA : failed \(error.localizedDescription)")
                return
            }
            self?.delegate?.userPublishedPost(self!)
        }
    }
    
    //MARK: - Helpers
    
    func uiConfigutarion() {
        view.backgroundColor = .black
        navigationItem.title = "Post"
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Publish", style: .done, target: self, action: #selector(publisheTapped))
        
        view.addSubview(pictureImageView)
        pictureImageView.setDimensions(height: 180, width: 180)
        
        pictureImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 10)
        pictureImageView.centerX(inView: view)
        pictureImageView.layer.cornerRadius = 10
        
        view.addSubview(postTxtContent)
        postTxtContent.anchor(top: pictureImageView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 12,paddingRight: 12,height: 64)
        
        view.addSubview(wordsCountLbl)
        wordsCountLbl.anchor(top:postTxtContent.bottomAnchor,right: view.rightAnchor,paddingTop: 12,paddingRight: 12)
        
    }
    
    func checkTextWordCount(_ textView: UITextView) {
        if textView.text.count > 120 {
            textView.deleteBackward()
        }
    }
}

extension PostCreationController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkTextWordCount(textView)
        let count = textView.text.count
        wordsCountLbl.text = "\(count)/120"
    }
}
