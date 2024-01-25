//
//  AuthInputView.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import UIKit

class AuthInputView: UIView {
    init(image: UIImage, textField: UITextField) {
        super.init(frame: .zero)
        backgroundColor = .clear
        let imageView = UIImageView()
        imageView.customMode()
        imageView.image = image
        imageView.tintColor = .label
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.7)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
