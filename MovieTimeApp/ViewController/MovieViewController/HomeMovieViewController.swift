//
//  HomeMovieViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 8.01.2024.
//

import UIKit

enum SectionType {
    case upcoming(viewModels: [HomeViewModel])
    case nowPlaying(viewModels: [HomeViewModel])
    case popular(viewModels: [HomeViewModel])
    case topRated(viewModels: [HomeViewModel])
    
    var title: String {
        switch self {
            case .upcoming:
                return "🎬 Upcoming Movies 🎬"
            case .nowPlaying:
                return "🎞️ Now Playing Movies 🎞️"
            case .popular:
                return "🎥 Popular Movies 🎥"
            case .topRated:
                return "⭐️ Top Rated Movies ⭐️"
        }
    }
}
class HomeMovieViewController: UIViewController {
    //MARK: - Properties
    
    private var sections = [SectionType]()
    private var selectedMoviesBySection = [[Movie]?]()
    private var genreData : [Genre]? = [Genre]()
    var viewModel : DetailMovieModel?
    public var movieArray : [Movie]? = [Movie]()
    private var casts : [Cast]? = [Cast]()
    private var videoData : [VideoResults]? = [VideoResults]()

    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return HomeMovieViewController.createSectionLayout(section: sectionIndex)
    })
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        fetchData()
        fetchGenreData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}
//MARK: - Helpers
extension HomeMovieViewController {
    //MARK: - Fetch Genres
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
    //MARK: - Fetch Movies
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        MovieManager.shared.performRequest(type: MovieData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .upcoming) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let movieData):
                if let movies = movieData.results {
                    let viewModels = movies.map { movie in
                        HomeViewModel(
                            movieTitle: movie.title ?? "",
                            moviePosterPath: movie.poster_path,
                            movieOverview: movie.overview ?? "",
                            movieReleaseDate: movie.release_date ?? "",
                            movieId: movie.id ?? 0,
                            movieVoteAverage: movie.vote_average ?? 0.0,
                            movieVoteCount: movie.vote_count ?? 0,
                            movieGenre: "Unknown Genre"
                        )
                    }
                    self.sections.append(.upcoming(viewModels: viewModels))
                    self.selectedMoviesBySection.append(movies)
                } else {
                    print("Movies data is nil.")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        MovieManager.shared.performRequest(type: MovieData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .nowPlaying) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let movieData):
                if let movies = movieData.results {
                    let viewModels = movies.map { movie in
                        HomeViewModel(
                            movieTitle: movie.title ?? "",
                            moviePosterPath: movie.poster_path,
                            movieOverview: movie.overview ?? "",
                            movieReleaseDate: movie.release_date ?? "",
                            movieId: movie.id ?? 0,
                            movieVoteAverage: movie.vote_average ?? 0.0,
                            movieVoteCount: movie.vote_count ?? 0,
                            movieGenre: "Unknown Genre"
                        )
                    }
                    self.sections.append(.nowPlaying(viewModels: viewModels))
                    self.selectedMoviesBySection.append(movies)
                } else {
                    print("Movies data is nil.")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        MovieManager.shared.performRequest(type: MovieData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .popular) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let movieData):
                if let movies = movieData.results {
                    let viewModels = movies.map { movie in
                        HomeViewModel(
                            movieTitle: movie.title ?? "",
                            moviePosterPath: movie.poster_path,
                            movieOverview: movie.overview ?? "",
                            movieReleaseDate: movie.release_date ?? "",
                            movieId: movie.id ?? 0,
                            movieVoteAverage: movie.vote_average ?? 0.0,
                            movieVoteCount: movie.vote_count ?? 0,
                            movieGenre: "Unknown Genre"
                        )
                    }
                    self.sections.append(.popular(viewModels: viewModels))
                    self.selectedMoviesBySection.append(movies)
                } else {
                    print("Movies data is nil.")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        MovieManager.shared.performRequest(type: MovieData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .topRated) { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let movieData):
                if let movies = movieData.results {
                    let viewModels = movies.map { movie in
                        HomeViewModel(
                            movieTitle: movie.title ?? "",
                            moviePosterPath: movie.poster_path,
                            movieOverview: movie.overview ?? "",
                            movieReleaseDate: movie.release_date ?? "",
                            movieId: movie.id ?? 0,
                            movieVoteAverage: movie.vote_average ?? 0.0,
                            movieVoteCount: movie.vote_count ?? 0,
                            movieGenre: "Unknown Genre"
                        )
                    }
                    self.sections.append(.topRated(viewModels: viewModels))
                    self.selectedMoviesBySection.append(movies)
                } else {
                    print("Movies data is nil.")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        group.notify(queue: .main) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private func style() {
        configureCollectionView()
    }
    //MARK: - Compositional CollectionView
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeMovieViewController.createSectionLayout(section: sectionIndex)
        }
        collectionView.collectionViewLayout.register(SectionHeaderView.self, forDecorationViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
     static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let headerSupplementary = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]

        switch section {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 2, trailing: 6)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .fractionalHeight(0.5)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = headerSupplementary
                return section
            case 1:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.75),
                    heightDimension: .fractionalHeight(1.0)),
                subitem: item,
                count: 2)
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.6),
                    heightDimension: .fractionalHeight(0.8)),
                subitem: verticalGroup,
                count: 1)
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = headerSupplementary
                return section
            case 2:
                let item = NSCollectionLayoutItem(
                 layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                 layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .fractionalHeight(1.0)),
                 subitem: item,
                 count: 3)
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                 layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .fractionalHeight(1.0)),
                 subitem: verticalGroup,
                 count: 2)
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = headerSupplementary
                return section
            case 3:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(0.75)),
                    subitems: [item,item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = headerSupplementary
                return section
            default:
                let item = NSCollectionLayoutItem(
                 layoutSize: NSCollectionLayoutSize(
                     widthDimension: .fractionalWidth(1.0),
                     heightDimension: .fractionalWidth(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                let group = NSCollectionLayoutGroup.vertical(
                 layoutSize: NSCollectionLayoutSize(
                     widthDimension: .fractionalWidth(1.0),
                     heightDimension: .absolute(390)),
                 subitem: item,
                 count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = headerSupplementary
                return section
        }
    }
}
extension HomeMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        switch sections[section] {
        case .upcoming(let viewModels),
             .nowPlaying(let viewModels),
             .popular(let viewModels),
             .topRated(let viewModels):
            return viewModels.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        let viewModel: HomeViewModel
        
        switch sections[indexPath.section] {
        case .upcoming(let viewModels),
             .nowPlaying(let viewModels),
             .popular(let viewModels),
             .topRated(let viewModels):
            viewModel = viewModels[indexPath.item]
        }
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let section = indexPath.section
        let movie: Movie

        switch sections[section] {
        case .upcoming(let viewModels),
             .nowPlaying(let viewModels),
             .popular(let viewModels),
             .topRated(let viewModels):
            guard indexPath.item < viewModels.count else { return }
            
            if let selectedMovies = selectedMoviesBySection[section], indexPath.item < selectedMovies.count {
                movie = selectedMovies[indexPath.item]
                navigateToDetailView(with: movie)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView, kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    func navigateToDetailView(with movie: Movie) {
        let detailViewController = DetailViewController()
        detailViewController.movieArray = [movie]
        detailViewController.genreData = genreData
        detailViewController.casts = casts
        detailViewController.videoData = videoData
        navigationController?.pushViewController(detailViewController, animated: true)
        navigationController?.navigationBar.tintColor = .white
    }
}
