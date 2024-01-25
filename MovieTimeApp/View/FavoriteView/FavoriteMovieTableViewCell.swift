//
//  FavoriteMovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 12.01.2024.
//

import Foundation
import UIKit

class FavoriteMovieTableViewCell: UITableViewCell {
    static let identifier = "FavoriteMovieCollectionViewCell"
    
    public let movieImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.customMode()
        imageView.customScreenPage()
        imageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        imageView.backgroundColor = .cyan
        return imageView
    }()
    public let movieNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    public let movieDateLabel: UILabel = {
       let label = UILabel()
        label.text = "Count"
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    public let movieVoteAverageLabel: UILabel = {
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.layer.cornerRadius = movieImageView.frame.size.height * 0.08
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension FavoriteMovieTableViewCell {
    private func setUpLayer() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
    }
    private func setup() {
        labelStackView = UIStackView(arrangedSubviews:[movieNameLabel, movieVoteAverageLabel, movieDateLabel])
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
}
