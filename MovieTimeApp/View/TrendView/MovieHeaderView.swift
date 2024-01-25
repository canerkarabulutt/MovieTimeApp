//
//  MovieHeaderView.swift
//  MovieApp
//
//  Created by Caner Karabulut on 2.01.2024.
//

import UIKit

class MovieHeaderView: UICollectionReusableView {
    //MARK: - Properties
    static let identifier = "HomeMovieHeaderView"
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 6
        imageView.layer.shadowColor = UIColor.label.cgColor
        imageView.layer.shadowOpacity = 2
        imageView.layer.shadowOffset = CGSize(width: -4, height: -4)
        return imageView
    }()
    private let headerLabel : UILabel = {
        let label = UILabel()
        label.text = "🔥 Trending Movies 🔥"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
}
//MARK: - Helpers
extension MovieHeaderView {
    private func setUpLayer() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 6
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: -4, height: -4)
    }
    private func style() {
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        setUpLayer()
    }
    private func layout() {
        addSubview(headerImageView)
        addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 12),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
    }
    public func configure(with viewModel: HomeViewModel) {
        viewModel.fetchImage { [weak self] result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.headerImageView.image = image
                    }
                case .failure(let error):
                    print("Image download error: \(error)")
                    break
            }
        }
    }
}
