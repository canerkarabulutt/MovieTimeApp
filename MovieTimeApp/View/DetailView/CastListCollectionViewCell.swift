//
//  CastListCollectionViewCell.swift
//  MovieTimeApp
//
//  Created by Caner Karabulut on 31.01.2024.
//

import Foundation
import UIKit

class CastListCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "CastListCollectionViewCell"
    
    public let castImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    public let castName: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    public let characterName: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.numberOfLines = 0
        label.textColor = .lightText
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    private var stackView = UIStackView()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension CastListCollectionViewCell {
    private func style() {
        castImage.translatesAutoresizingMaskIntoConstraints = false
        stackView = UIStackView(arrangedSubviews: [castName, characterName])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 6
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize(width: -4, height: -4)
    }
    private func layout() {
        addSubview(castImage)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            castImage.topAnchor.constraint(equalTo: topAnchor),
            castImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            castImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            castImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: castImage.trailingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    func configure(with cast: Cast?) {
        castName.text = cast?.name ?? "N/A"
        characterName.text = cast?.character
        if let profilePath = cast?.profile_path {
            let imageURL = URL(string: "\(MovieConstants.baseImageURL)\(profilePath)")
            castImage.kf.setImage(with: imageURL)
        } else {
            castImage.image = UIImage(named: "default_profile_image")
        }
    }
}
