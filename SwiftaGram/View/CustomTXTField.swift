//
//  CustomTXTField.swift
//  SwiftaGram
//
//  Created by alta on 9/5/22.
//

import UIKit

class CustomTXTFIeld : UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        keyboardType = .emailAddress
        backgroundColor = UIColor(white:1,alpha: 0.1)
        setHeight(50)
        attributedPlaceholder =  NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
