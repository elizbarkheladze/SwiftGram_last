//
//  NewTextView.swift
//  SwiftaGram
//
//  Created by alta on 9/8/22.
//

import Foundation
import UIKit


class NewTextView: UITextView {
    //MARK: - Properties
    var placeHolderText : String? {
        didSet{
            placeHolderLbl.text = placeHolderText
        }
    }
    
    
     let placeHolderLbl: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    var placeHolderCenter = true {
        didSet{
            if placeHolderCenter{
                placeHolderLbl.centerY(inView: self)
                placeHolderLbl.anchor(left:leftAnchor, right : rightAnchor,paddingLeft: 8)
                
            } else {
                placeHolderLbl.anchor(top:topAnchor,left: leftAnchor,paddingTop: 7,paddingLeft: 8)
            }
        }
    }
    
    override init (frame : CGRect, textContainer: NSTextContainer?){
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeHolderLbl)
        placeHolderLbl.anchor(top:topAnchor,left: leftAnchor,paddingTop: 7,paddingLeft: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textEntered), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textEntered() {
        placeHolderLbl.isHidden = !text.isEmpty
    }
}
