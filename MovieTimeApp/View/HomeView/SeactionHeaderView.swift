//
//  SeactionHeaderView.swift
//  MovieApp
//
//  Created by Caner Karabulut on 8.01.2024.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = frame.width
        let height = frame.height
        titleLabel.frame = CGRect(x: 20, y: 0, width: width, height: height)
    }
    
    public func configure(with title: String) {
        titleLabel.text = title
    }
    public func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

