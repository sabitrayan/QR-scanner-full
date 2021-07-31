//
//  ExtensionUI.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 13.06.2021.
//

import UIKit

class CardTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(placeholderText: String, keyboard: UIKeyboardType) {
        super.init(frame: .zero)
        placeholder = placeholderText
        keyboardType = keyboard
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

