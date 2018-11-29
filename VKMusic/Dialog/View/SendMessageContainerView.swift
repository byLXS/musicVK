//
//  sendMessageContainerView.swift
//  VKMusic
//
//  Created by Robert on 17.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit.UIView

class SendMessageContainerView: UIView {
    
    var inputMessage: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.layer.borderWidth = 0.3
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        textField.placeholder = "Оставьте комментарий..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addSubview(inputMessage)
        self.addSubview(sendButton)
        
        inputMessage.leftAnchor.constraint(equalTo: leftAnchor,constant: 12).isActive = true
        inputMessage.rightAnchor.constraint(equalTo: rightAnchor,constant: -12).isActive = true
        inputMessage.topAnchor.constraint(equalTo: topAnchor,constant: 8).isActive = true
        inputMessage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        sendButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: inputMessage.bottomAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    

}

