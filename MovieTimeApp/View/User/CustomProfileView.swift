//
//  CustomProfileView.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import UIKit

class CustomProfileView: UIView {
    init(label: UILabel) {
        super.init(frame: .zero)
        layer.borderWidth = 1.7
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 10
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let label = label
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

