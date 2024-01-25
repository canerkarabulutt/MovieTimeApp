//
//  MainTabBarViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 21.12.2023.
//

import UIKit
import FirebaseAuth

class MainTabBarViewController: UITabBarController {
    let homeVC = HomeMovieViewController()
    let trendingVC = TrendingViewController()
    let searchVC = SearchMovieViewController()
    let favoriteVC = FavoriteViewController()
    let profileVC = ProfileViewController()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        fetchUser()
    }
    override func viewDidAppear(_ animated: Bool) {
        userStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpTabBar()
    }
    // Fetch User
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        AuthService.fetchUser(uid: uid) { user in
            self.profileVC.user = user
        }
    }
    // User
    private func userStatus() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginViewController())
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
        }else {
            print("There is a user.")
        }
    }
    private func signOut() {
        do {
            try Auth.auth().signOut()
            userStatus()
        }catch {
            
        }
    }
    // Setup Tab Bar
    private func setUpTabBar() {
        
        viewControllers = [
            configureViewController(rootViewController: homeVC, title: "Home", image: "house"),
            configureViewController(rootViewController: trendingVC, title: "Today Trendings", image: "tv"),
            configureViewController(rootViewController: searchVC, title: "Search", image: "globe"),
            configureViewController(rootViewController: favoriteVC, title: "✨Favorites✨", image: "star"),
            configureViewController(rootViewController: profileVC, title: "Settings", image: "gear")
        ]
    }
    private func configureViewController(rootViewController: UIViewController, title: String, image: String) -> UINavigationController {
        
        let appereance = UINavigationBarAppearance()
        appereance.configureWithDefaultBackground()
        let controller = UINavigationController(rootViewController: rootViewController)
        rootViewController.title = title
        controller.tabBarItem.title = title
        controller.navigationBar.prefersLargeTitles = true
        controller.navigationItem.largeTitleDisplayMode = .automatic
        controller.tabBarItem.image = UIImage(systemName: image)
        return controller
    }
    private func configureTabBar() {
        let shape = CAShapeLayer()
        let bezier = UIBezierPath(roundedRect: CGRect(x: 10, y: (self.tabBar.bounds.minY) - 16, width: (self.tabBar.bounds.width) - 20 , height: (self.tabBar.bounds.height) + 28), cornerRadius: (self.tabBar.bounds.height) / 1.5)
        shape.path = bezier.cgPath
        shape.fillColor = UIColor.darkGray.cgColor
        self.tabBar.itemPositioning = .fill
        self.tabBar.itemWidth = ((self.tabBar.bounds.width) - 20) / 5
        self.tabBar.tintColor = UIColor.systemBackground.withAlphaComponent(0.8)
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
        self.tabBar.layer.insertSublayer(shape, at: 0)
    }
}
