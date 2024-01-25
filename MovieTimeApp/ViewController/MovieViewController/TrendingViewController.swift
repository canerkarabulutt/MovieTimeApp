//
//  TrendingViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.01.2024.
//

import UIKit

class TrendingViewController: UIViewController {
    //MARK: - Properties
    private var tvShowsButton: UIBarButtonItem!
    private var moviesButton: UIBarButtonItem!
    private var container = Container()
    
    private let trendMoviesViewController = TrendMoviesViewController()
    private let trendTvShowsViewController = TrendTvShowsViewController()
    private lazy var viewControllers: [UIViewController] = [TrendMoviesViewController(), TrendTvShowsViewController()]
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    private func configureBarItem(text: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}
//MARK: - Helpers
extension TrendingViewController {
    private func style() {
        self.navigationController?.navigationBar.tintColor = .systemBackground
        moviesButton = UIBarButtonItem(customView: configureBarItem(text: "Movies", selector: #selector(handleMoviesButton)))
        tvShowsButton = UIBarButtonItem(customView: configureBarItem(text: "Tv Series", selector: #selector(handleTvShowsButton)))
        moviesButton.customView?.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        moviesButton.customView?.layer.borderWidth = 0.4
        moviesButton.customView?.layer.borderColor = UIColor.lightGray.cgColor
        moviesButton.customView?.layer.cornerRadius = 12
        tvShowsButton.customView?.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        tvShowsButton.customView?.layer.borderWidth = 0.4
        tvShowsButton.customView?.layer.borderColor = UIColor.lightGray.cgColor
        tvShowsButton.customView?.layer.cornerRadius = 6
        
        self.navigationItem.leftBarButtonItem = moviesButton
        self.navigationItem.rightBarButtonItem = tvShowsButton
        handleMoviesButton()
        configureContainer()
    }
    private func configureContainer() {
        guard let containerView = container.view else { return }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
//MARK: - Selector
extension TrendingViewController {
    
    @objc private func handleMoviesButton(){
        if self.container.children.first == TrendTvShowsViewController() { return }
        self.container.add(viewControllers[0])
        self.viewControllers[0].view.alpha = 0
        UIView.animate(withDuration: 1) {
            self.moviesButton.customView?.alpha = 1
            self.tvShowsButton.customView?.alpha = 0.5
            self.viewControllers[0].view.alpha = 1
            self.viewControllers[1].view.frame.origin.x = -1000
        } completion: { _ in
            self.viewControllers[1].remove()
            self.viewControllers[1].view.frame.origin.x = 0
        }
    }
    @objc private func handleTvShowsButton(){
        if self.container.children.first == TrendMoviesViewController() { return }
        self.container.add(viewControllers[1])
        self.viewControllers[1].view.alpha = 0
        UIView.animate(withDuration: 1) {
            self.moviesButton.customView?.alpha = 0.5
            self.tvShowsButton.customView?.alpha = 1
            self.viewControllers[1].view.alpha = 1
            self.viewControllers[0].view.frame.origin.x = +1000
        } completion: { _ in
            self.viewControllers[0].remove()
            self.viewControllers[0].view.frame.origin.x = 0
        }
    }
}
