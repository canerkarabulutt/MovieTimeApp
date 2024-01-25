//
//  SearchMovieViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 9.01.2024.
//

import UIKit

class SearchMovieViewController: UIViewController {
    //MARK: - Properties
    private var movieArray : [Movie]?
    private var selectedMovie : Movie?
    private var genreData : [Genre]? = [Genre]()
    public var casts : [Cast]? = [Cast]()
    public var videoData : [VideoResults]? = [VideoResults]()
    
    private let searchCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchDiscoverMovie()
    }
}
//MARK: - Service
extension SearchMovieViewController {
    private func fetchDiscoverMovie() {
        MovieManager.shared.performRequest(type: MovieData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .discover) { [weak self] result in
            switch result {
                case .success(let movieData):
                    self?.movieArray = movieData.results
                    DispatchQueue.main.async {
                        self?.searchCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
//MARK: - Helpers
extension SearchMovieViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search for a Movie or Tv show"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.backgroundColor = .systemBackground
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.cellIdentifier)
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(searchCollectionView)
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension SearchMovieViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.cellIdentifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        let movies = movieArray?[indexPath.row]
        cell.configure(with: SearchCollectionViewCellViewModel(
            movieTitle: movies?.original_title ?? "",
            movieCount: movies?.vote_count ?? 0,
            movieVoteAverage: movies?.vote_average ?? 0,
            moviePosterPath: movies?.poster_path))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedMovie = self.movieArray?[indexPath.row].self
        navigateToDetailView(with: selectedMovie!)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-20)
        return CGSize(width: width, height: width / 1.333)
    }
}
//MARK: - UISearchBarDelegate
extension SearchMovieViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchDiscoverMovie()
        } else {
            MovieManager.shared.performRequest(type: MovieData.self, query: searchText, externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .none) { [weak self] result in
                switch result {
                    case .success(let movieData):
                        self?.movieArray = movieData.results
                        DispatchQueue.main.async {
                            self?.searchCollectionView.reloadData()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchDiscoverMovie()
    }
    func navigateToDetailView(with movie: Movie) {
        let detailViewController = DetailViewController()
        detailViewController.movieArray = [movie]
        detailViewController.genreData = genreData
        detailViewController.casts = casts
        detailViewController.videoData = videoData
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
