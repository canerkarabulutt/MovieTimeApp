//
//  ProfileView.swift
//  MovieApp
//
//  Created by Caner Karabulut on 24.01.2024.
//

import UIKit
import FirebaseAuth
import SDWebImage

protocol ProfileViewProtocol: AnyObject {
    func signOutProfile()
}

class ProfileView: UIView {
    //MARK: - Properties
    var user: UserModel? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileViewProtocol?
    
    private let gradient = CAGradientLayer()
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.5
        return imageView
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var usernameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.purple
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignOutButton), for: .touchUpInside)
        return button
    }()
    private lazy var stackView = UIStackView()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
}
//MARK: - Selector
extension ProfileView {
    @objc private func handleSignOutButton(_ sender: UIButton) {
        delegate?.signOutProfile()
    }
}
//MARK: - Helpers
extension ProfileView {
    private func style() {
            clipsToBounds = true
            gradient.locations = [0,1]
            gradient.colors = [UIColor.systemMint.cgColor, UIColor.systemCyan.cgColor]
            layer.addSublayer(gradient)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 120 / 2
        
        stackView = UIStackView(arrangedSubviews: [nameLabel, usernameLabel, emailLabel, signOutButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
    }
    private func layout() {
        addSubview(profileImageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    private func attributedTitle(headerTitle: String, title: String) -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: "\(headerTitle): ", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.9), .font: UIFont.systemFont(ofSize: 16, weight: .bold)])
        attributed.append(NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18, weight: .heavy)]))
        return attributed
    }
    private func configure() {
        guard let user = self.user else { return }
        self.usernameLabel.attributedText = attributedTitle(headerTitle: "Username", title: "\(user.username)")
        self.nameLabel.attributedText = attributedTitle(headerTitle: "Name", title: "\(user.name)")
        self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
    }
}
