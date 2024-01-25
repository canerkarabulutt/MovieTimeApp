//
//  ProfileViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 16.01.2024.
//

import UIKit
import SDWebImage
import FirebaseAuth

class ProfileViewController: UIViewController {
    //MARK: - Properties
    var user: UserModel? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = . scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var nameContainer: CustomProfileView = {
        let customProfileView = CustomProfileView(label: nameLabel)
        return customProfileView
    }()
    private let nameLabel = UILabel()
    
    private lazy var emailContainer: CustomProfileView = {
        let customProfileView = CustomProfileView(label: emailLabel)
        return customProfileView
    }()
    private let emailLabel = UILabel()
    
    private lazy var usernameContainer: CustomProfileView = {
        let customProfileView = CustomProfileView(label: usernameLabel)
        return customProfileView
    }()
    private let usernameLabel = UILabel()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(handleSignOutButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    private var stackView = UIStackView()
    
    private let logoImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .purple
        imageView.image = UIImage(named: "movieTime")
        return imageView
    }()
    //MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}
//MARK: - Selector
extension ProfileViewController {
   @objc private func handleSignOutButton() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginViewController())
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
        }catch {
        }
    }
}
//MARK: - Helpers
extension ProfileViewController {
    private func style() {
        backgroundGradientColor()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 160 / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        
        stackView = UIStackView(arrangedSubviews: [emailContainer,usernameContainer, nameContainer, signOutButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(profileImageView)
        view.addSubview(stackView)
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 160),
            profileImageView.widthAnchor.constraint(equalToConstant: 160),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 32),
            
            logoImageView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    private func attributedTitle(title: String, info: String) -> NSMutableAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(title): ", attributes: [.foregroundColor: UIColor.red, .font: UIFont.preferredFont(forTextStyle: .largeTitle)])
        attributedTitle.append(NSAttributedString(string: info, attributes: [.foregroundColor: UIColor.label, .font: UIFont.preferredFont(forTextStyle: .headline)]))
        return attributedTitle
    }
    private func configure() {
        guard let user = self.user else { return }
        let viewModel = ProfileViewModel(user: user)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        self.nameLabel.attributedText = attributedTitle(title: "Name", info: viewModel.name!)
        self.emailLabel.attributedText = attributedTitle(title: "Email", info: viewModel.email!)
        self.usernameLabel.attributedText = attributedTitle(title: "Username", info: viewModel.username!)
    }
}
