//
//  TrendMoviesViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.01.2024.
//

import UIKit

class TrendMoviesViewController: UIViewController {
    //MARK: - Properties
    private var trendMovies : [Movie]? = []
    private var headerView : MovieHeaderView?
    
    private var genreData : [Genre]? = [Genre]()
    var viewModel : DetailMovieModel?
    public var movieArray : [Movie]? = [Movie]()
    private var casts : [Cast]? = [Cast]()
    private var videoData : [VideoResults]? = [VideoResults]()
    private var selectedMovie : Movie?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 6, bottom: 50, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchHeaderView()
        fetchGenreData()
    }
}
//MARK: - Service
extension TrendMoviesViewController {
    private func fetchHeaderView() {
        MovieManager.shared.performRequest(type: MovieData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .discover) { [weak self] result in
            switch result {
                case .success(let movieData):
                    if let selectedRandom = movieData.results?.randomElement() {
                        self?.headerView?.configure(with: HomeViewModel(movieTitle: selectedRandom.original_title ?? "", moviePosterPath: selectedRandom.poster_path, movieOverview: selectedRandom.overview, movieReleaseDate: selectedRandom.release_date ?? "", movieId: selectedRandom.id ?? 0, movieVoteAverage: selectedRandom.vote_average ?? 0, movieVoteCount: selectedRandom.vote_count ?? 0, movieGenre: ""))
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    private func fetchGenreData(){
        MovieManager.shared.performRequest(type: GenreData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .none, completion: { results in
            switch results{
            case.success(let genres):
                self.genreData = genres.genres
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    private func fetchData() {
        MovieManager.shared.performRequest(type: MovieData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .trendingMovies) { [weak self] result in
            switch result {
                case .success(let movieData):
                    self?.trendMovies = movieData.results
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
//MARK: - Helpers
extension TrendMoviesViewController {
    private func style() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrendMoviesCollectionViewCell.self, forCellWithReuseIdentifier: TrendMoviesCollectionViewCell.cellIdentifier)
        collectionView.register(MovieHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieHeaderView.identifier)
        fetchData()
    }
    private func layout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
//MARK: - UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension TrendMoviesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendMovies?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendMoviesCollectionViewCell.cellIdentifier, for: indexPath) as? TrendMoviesCollectionViewCell else { return UICollectionViewCell() }
        let movies = trendMovies?[indexPath.row]
        cell.configure(with: HomeViewModel(movieTitle: movies?.original_title ?? "", moviePosterPath: movies?.poster_path, movieOverview: movies?.overview, movieReleaseDate: movies?.release_date ?? "", movieId: movies?.id ?? 0, movieVoteAverage: movies?.vote_average ?? 0, movieVoteCount: movies?.vote_count ?? 0, movieGenre: ""))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 20) / 2
        return CGSize(width: width, height: width * 1.333)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieHeaderView.identifier, for: indexPath) as? MovieHeaderView else {
                return UICollectionReusableView()
            }
            if let selectedRandom = trendMovies?.randomElement() {
                headerView.configure(with: HomeViewModel(movieTitle: selectedRandom.original_title ?? "", moviePosterPath: selectedRandom.poster_path, movieOverview: selectedRandom.overview, movieReleaseDate: selectedRandom.release_date ?? "", movieId: selectedRandom.id ?? 0, movieVoteAverage: selectedRandom.vote_average ?? 0, movieVoteCount: selectedRandom.vote_count ?? 0, movieGenre: ""))
            }
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.width / 1.5
        return .init(width: width, height: width * 1.8)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = trendMovies?[indexPath.row]
        navigateToDetailView(with: selectedMovie)
    }
    private func navigateToDetailView(with movie: Movie?) {
        guard let movie = movie else { return }
        let detailViewController = DetailViewController()
        detailViewController.movieArray = [movie]
        detailViewController.genreData = genreData
        detailViewController.casts = casts
        detailViewController.videoData = videoData
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
