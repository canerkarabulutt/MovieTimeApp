//
//  CastDetailViewController.swift
//  MovieTimeApp
//
//  Created by Caner Karabulut on 31.01.2024.
//

import Foundation
import UIKit

class CastListViewController: UIViewController {
    //MARK: - Properties
    var casts: [Cast]? {
        didSet {
            castListCollectionView.reloadData()
        }
    }
    private let castListCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}
//MARK: - Helpers
extension CastListViewController {
    private func style() {
        castListCollectionView.delegate = self
        castListCollectionView.dataSource = self
        castListCollectionView.backgroundColor = .systemBackground
        castListCollectionView.register(CastListCollectionViewCell.self, forCellWithReuseIdentifier: CastListCollectionViewCell.identifier)
        castListCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(castListCollectionView)
        
        NSLayoutConstraint.activate([
            castListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            castListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            castListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            castListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CastListViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastListCollectionViewCell.identifier, for: indexPath) as? CastListCollectionViewCell else { return UICollectionViewCell()
        }
        if let cast = casts?[indexPath.row] {
            cell.configure(with: cast)
        }
        return cell
    }
}
//MARK: - UICollect
extension CastListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: castListCollectionView.frame.width, height: castListCollectionView.frame.height / 5)
    }
}
