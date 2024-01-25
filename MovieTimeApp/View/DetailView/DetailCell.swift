//
//  DetailCell.swift
//  MovieApp
//
//  Created by Caner Karabulut on 17.01.2024.
//

import UIKit

class DetailCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "DetailCell"
    
    public var movieArray : [Movie]? = [Movie]()
    public var genreData : [Genre]? = [Genre]()
    public var viewModel : DetailMovieModel?
    public var viewModelArray : [DetailMovieModel]? = []
    private var movieID : String?
    private var id : Int?
    private var posterString : String?

    private let moviePosterView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 6
        imageView.layer.shadowColor = UIColor.label.cgColor
        imageView.layer.shadowOpacity = 2
        imageView.layer.shadowOffset = CGSize(width: -4, height: -4)
        return imageView
    }()
    private let movieNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let movieAverageLabel: UILabel = {
       let label = UILabel()
        label.text = "Rate"
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let movieYearLabel: UILabel = {
       let label = UILabel()
        label.text = "Year"
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let movieOverviewLabel: UILabel = {
       let label = UILabel()
        label.text = "Overview"
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()
    private var stackView = UIStackView()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    //    loadDetails()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Helpers
extension DetailCell {
    private func style() {
        moviePosterView.translatesAutoresizingMaskIntoConstraints = false
        movieAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieYearLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        stackView = UIStackView(arrangedSubviews: [movieNameLabel, movieYearLabel])
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(moviePosterView)
        addSubview(movieNameLabel)
        addSubview(movieYearLabel)
        addSubview(movieAverageLabel)
        addSubview(movieOverviewLabel)
        addSubview(favoriteButton)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            moviePosterView.topAnchor.constraint(equalTo: topAnchor),
            moviePosterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviePosterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moviePosterView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 3/7),
            moviePosterView.widthAnchor.constraint(equalTo: widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: moviePosterView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -12),
            
            movieAverageLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            movieAverageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            movieAverageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 120),
            favoriteButton.bottomAnchor.constraint(equalTo: topAnchor, constant: -10),
            favoriteButton.topAnchor.constraint(equalTo: bottomAnchor, constant: 16),
            
            movieOverviewLabel.topAnchor.constraint(equalTo: movieAverageLabel.bottomAnchor, constant: 10),
            movieOverviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            movieOverviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    func configure(with viewModel: DetailMovieModel?) {
        guard let viewModel = viewModel else { return }
        
        movieNameLabel.text = viewModel.movieTitle
        movieYearLabel.text = viewModel.dateAndGenre
        movieAverageLabel.text = viewModel.score
        movieOverviewLabel.text = viewModel.overview
        if let posterURL = viewModel.posterImage {
            moviePosterView.kf.setImage(with: posterURL)
        }
    }
}
/*extension DetailCell {
    public func loadDetails(){
        if movieArray?.isEmpty == false {
            let title = movieArray?[0].title ?? movieArray?[0].original_title ?? ""
            let posterURL = movieArray?[0].poster_path ?? ""
            let overview = movieArray?[0].overview ?? ""
            let releaseDate = movieArray?[0].release_date ?? ""
            let movieId = movieArray?[0].id ?? 0
            let voteAverage = movieArray?[0].vote_average ?? 0
            let voteCount = movieArray?[0].vote_count ?? 0
            
            guard let movieGenreArray = movieArray?[0].genre_ids else { return }
            let movieGenreCount = movieGenreArray.count
            
            guard let genreDataCount = self.genreData?.count else { return }
            
            var genreResult : String = ""
            
            for movieGenreIndex in 0...movieGenreCount - 1{
                for gDataIndex in 0...genreDataCount - 1 {
                    if movieGenreArray[movieGenreIndex] == self.genreData?[gDataIndex].id{
                        guard let genreName = self.genreData?[gDataIndex].name else { return }
                        genreResult = genreResult + genreName + ", "
                    }
                }
            }
            self.viewModel = DetailMovieModel(movieTitle: title, posterURL: posterURL, overview: overview, releaseDate: releaseDate, id: movieId, voteAverage: voteAverage, voteCount: voteCount, genre: genreResult, popularity: 0)
        }
        movieNameLabel.text = viewModel?.movieTitle
        movieYearLabel.text = viewModel?.dateAndGenre
        movieAverageLabel.text = viewModel?.score
        movieOverviewLabel.text = viewModel?.overview
        moviePosterView.kf.setImage(with: viewModel?.posterImage)
        posterString = "\(MovieConstants.baseImageURL)" + (viewModel?.posterURL ?? "")
        
        MovieManager.shared.performRequest(type: MovieDetailsData.self, query: "", externalID: "", movieID: viewModel?.id ?? 0, movieIDSelection: .movieDetails, movieURL: .none) { results in
            switch results{
            case .success(let details):
                self.id = details.id
                self.movieID = details.imdb_id
            case .failure(let error):
                print(error)
            }
        }
        configure(with: viewModel)
    }
}
*/
