//
//  CommentInputView.swift
//  SwiftaGram
//
//  Created by alta on 9/14/22.
//

import UIKit

protocol CommentInputViewDelegate : AnyObject{
    func commentInputView(_ commentInputView: CommentInputView, uploadComment: String)
}

class CommentInputView: UIView {
    
    weak var delegate : CommentInputViewDelegate?
    
    private let textInput : NewTextView = {
        let textView = NewTextView()
        textView.placeHolderText = "Type Comment >>>"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.placeHolderCenter = true
        return textView
    }()
    
    private let commnetBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comment", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(publishComment), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        addSubview(commnetBtn)
        commnetBtn.anchor(top:topAnchor,right: rightAnchor,paddingLeft: 8)
        commnetBtn.setDimensions(height: 50, width: 50)
        
        addSubview(textInput)
        textInput.anchor(top:topAnchor,left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right:commnetBtn.leftAnchor,paddingTop: 8,paddingLeft: 8,paddingBottom: 8,paddingRight: 8)
        
        let dividerLine = UIView()
        dividerLine.backgroundColor = .black
        addSubview(dividerLine)
        dividerLine.anchor(top:topAnchor,left:leftAnchor,right:rightAnchor,height: 0.8)
    }
    
    override var intrinsicContentSize: CGSize {
        .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func publishComment() {
        delegate?.commentInputView(self, uploadComment: textInput.text)
    }
    
    func deleteCommentTxt() {
        textInput.text = nil
        textInput.placeHolderLbl.isHidden = false
    }
}
