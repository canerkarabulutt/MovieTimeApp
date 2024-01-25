//
//  SearchCollectionViewCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.12.2023.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let cellIdentifier = "SearchCollectionViewCell"
        
    private let movieImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.customMode()
        imageView.customScreenPage()
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.backgroundColor = .cyan
        return imageView
    }()
    private let movieNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    private let movieVoteCountLabel: UILabel = {
       let label = UILabel()
        label.text = "Count"
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let movieVoteAverageLabel: UILabel = {
       let label = UILabel()
        label.text = "Count"
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private var labelStackView: UIStackView!
    private var fullStackView: UIStackView!
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        movieImageView.image = nil
        movieNameLabel.text = nil
        movieVoteCountLabel.text = nil
        movieVoteAverageLabel.text = nil
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
}
//MARK: - Helpers
extension SearchCollectionViewCell {
    
    private func setUpLayer() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
    }
    private func style() {
        labelStackView = UIStackView(arrangedSubviews:[movieNameLabel, movieVoteAverageLabel, movieVoteCountLabel])
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        
        fullStackView = UIStackView(arrangedSubviews: [movieImageView, labelStackView])
        fullStackView.spacing = 16
        fullStackView.distribution = .fillProportionally
        fullStackView.axis = .horizontal
        fullStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpLayer()
    }
    private func layout() {
        addSubview(fullStackView)
        
        NSLayoutConstraint.activate([
            fullStackView.topAnchor.constraint(equalTo: topAnchor),
            fullStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fullStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fullStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    public func configure(with viewModel: SearchCollectionViewCellViewModel) {
        movieNameLabel.text = viewModel.movieTitle
        movieVoteAverageLabel.text = viewModel.movieVoteAverageText
        movieVoteCountLabel.text = viewModel.movieCountText
        viewModel.fetchImage { [weak self] result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.movieImageView.image = image
                    }
                case .failure(let error):
                    print("Image download error: \(error)")
                    break
            }
        }
    }
}
