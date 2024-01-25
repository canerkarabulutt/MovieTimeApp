//
//  HomeCollectionViewCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 17.01.2024.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionCell"
                
    //MARK: - Properties
   private let movieImageView: UIImageView = {
      let imageView = UIImageView()
       imageView.customMode()
       imageView.layer.cornerRadius = 4
       return imageView
   }()
   private let movieNameLabel: UILabel = {
      let label = UILabel()
       label.text = "Name"
       label.numberOfLines = 0
       label.textColor = .label
       label.textAlignment = .center
       label.lineBreakMode = .byWordWrapping
       label.font = .systemFont(ofSize: 18, weight: .light)
       return label
   }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
        setUpLayer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        movieImageView.image = nil
        movieNameLabel.text = nil
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
}
//MARK: - Helpers
extension HomeCollectionViewCell {
    private func setUpLayer() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: -4, height: -4)
    }
    private func style() {
        movieImageView.frame = bounds
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieNameLabel)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
      
            movieNameLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            movieNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    public func configure(with viewModel: HomeViewModel) {
        movieNameLabel.text = viewModel.movieTitle
        viewModel.fetchImage { [weak self] result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.movieImageView.image = self?.scaleImage(image: image ?? UIImage(), toSize: self?.bounds.size ?? CGSize(width: 100, height: 100))
                        self?.movieImageView.contentMode = .scaleAspectFill
                    }
                case .failure(let error):
                    print("Image download error: \(error)")
                    break
            }
        }
    }
    private func scaleImage(image: UIImage, toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage ?? image
    }
}
