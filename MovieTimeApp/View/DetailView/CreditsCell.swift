//
//  CreditsCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import UIKit

class CreditsCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "CreditsCell"
    
    public let castImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
extension CreditsCell {
    private func style() {
        stackView = UIStackView(arrangedSubviews: [castImage, castName, characterName])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        

        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 6
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize(width: -4, height: -4)
    }
    private func layout() {
        addSubview(stackView)

        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
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
