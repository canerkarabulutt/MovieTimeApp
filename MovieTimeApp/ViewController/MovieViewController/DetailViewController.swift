//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 18.01.2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import Kingfisher

class DetailViewController: UIViewController {
    private var movieID : String?
    private var id : Int?
    private var posterString : String?
    public var viewModel : DetailMovieModel?
    public var movieArray : [Movie]? = [Movie]()
    public var casts : [Cast]? = [Cast]()
    public var genreData : [Genre]? = [Genre]()
    public var videoData : [VideoResults]? = [VideoResults]()
    
    
    //MARK: - Properties
    private let detailCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical
         layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.isHidden = false
         collectionView.alpha = 1
         return collectionView
    }()
    private let castCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .horizontal
         layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.isHidden = false
         collectionView.alpha = 1
         return collectionView
    }()
    private let trailerCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .horizontal
         layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
         layout.minimumLineSpacing = 10
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.isHidden = false
         collectionView.alpha = 1
         return collectionView
    }()
    private let moviePosterView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
    private var isFavorite = false

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.setContentHuggingPriority(.required, for: .vertical)
        button.addTarget(self, action: #selector(handleFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    private let scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        return scrollView
    }()
    private var labelStackView = UIStackView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        style()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDetails()
        loadVideos()
        trimTextForLabel(movieOverviewLabel, maxLength: 250)
    }
}
//MARK: - Methods
extension DetailViewController {
    @objc private func handleFavoriteButton() {
        isFavorite.toggle()
        
        if isFavorite {
            let filledImage = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
            favoriteButton.setImage(filledImage, for: .normal)
            addWatchlist()
        } else {
            let emptyImage = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
            favoriteButton.setImage(emptyImage, for: .normal)
        }
        updateFavoriteStatus(isFavorite)
    }
    private func updateFavoriteStatus(_ isFavorite: Bool) {
        print("Favorite Status : \(isFavorite ? "Yes" : "No")")
    }
    //Update View
    private func loadDetails(){
        //Check If The Data Fetched From Watchlist or SearchVC
        if movieArray?.isEmpty == false {
            let title = movieArray?[0].title ?? movieArray?[0].original_title ?? ""
            let posterURL = movieArray?[0].poster_path ?? ""
            let overview = movieArray?[0].overview ?? ""
            let releaseDate = movieArray?[0].release_date ?? ""
            let movieId = movieArray?[0].id ?? 0
            let voteAverage = movieArray?[0].vote_average ?? 0
            let voteCount = movieArray?[0].vote_count ?? 0
            let popular = movieArray?[0].popularity ?? 0
            
            guard let movieGenreArray = movieArray?[0].genre_ids else { return }
            let movieGenreCount = movieGenreArray.count
            
            guard let genreDataCount = self.genreData?.count else { return }
            
            var genreResult : String = ""
            
            for movieGenreIndex in 0...movieGenreCount - 1{
                for gDataIndex in 0..<genreDataCount {
                    if movieGenreArray[movieGenreIndex] == self.genreData?[gDataIndex].id{
                        guard let genreName = self.genreData?[gDataIndex].name else { return }
                        genreResult = genreResult + genreName + ", "
                    }
                }
            }
            self.viewModel = DetailMovieModel(movieTitle: title, posterURL: posterURL, overview: overview, releaseDate: releaseDate, id: movieId, voteAverage: voteAverage, voteCount: voteCount, genre: genreResult, popularity: popular)
        }
        //Load The Latest Data
        movieNameLabel.text = viewModel?.movieTitle
        movieYearLabel.text = viewModel?.dateAndGenre
        movieAverageLabel.text = viewModel?.score
        movieOverviewLabel.text = viewModel?.overview
        moviePosterView.kf.setImage(with: viewModel?.posterImage)
        posterString = "\(MovieConstants.baseImageURL)" + (viewModel?.posterURL ?? "")
        //Get External ID
        MovieManager.shared.performRequest(type: MovieDetailsData.self, query: "", externalID: "", movieID: viewModel?.id ?? 0, movieIDSelection: .movieDetails, movieURL: .none) { results in
            switch results{
            case .success(let details):
                self.id = details.id
                self.movieID = details.imdb_id
            case .failure(let error):
                print(error)
            }
        }
        //Fetch Casts
        MovieManager.shared.performRequest(type: CreditsData.self, query: "", externalID: "", movieID: viewModel?.id ?? 0, movieIDSelection: .credits, movieURL: .none) { results in
            switch results{
            case.success(let cast):
                DispatchQueue.main.async {
                    self.casts = cast.cast
                    self.castCollectionView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //Load Movie Videos
    func loadVideos(){
        MovieManager.shared.performRequest(type: VideoData.self, query: "", externalID: "", movieID: viewModel?.id ?? 0, movieIDSelection: .videos, movieURL: .none) { results in
            switch results {
            case.success(let video):
                DispatchQueue.main.async {
                    self.videoData = video.results
                    self.trailerCollectionView.reloadData()
                }
            case.failure( let error):
                print(error.localizedDescription)
            }
        }
    }
    //Prepare For Watchlist Button
    private func addWatchlist(){
        let uuid = UUID().uuidString
        let docData : [String: Any] = [FirestoreConstants.id : id as Any,
                                       FirestoreConstants.movieId : movieID as Any,
                                       FirestoreConstants.title : movieNameLabel.text!,
                                       FirestoreConstants.date : movieYearLabel.text!,
                                       FirestoreConstants.overview : movieOverviewLabel.text!,
                                       FirestoreConstants.score : movieAverageLabel.text!,
                                       FirestoreConstants.posterPath : posterString as Any,
                                       FirestoreConstants.uploadDate : FieldValue.serverTimestamp(),
                                       FirestoreConstants.uuid : uuid,
                                       FirestoreConstants.email : Auth.auth().currentUser?.email as Any]
        
        Firestore.firestore().collection(FirestoreConstants.collectionName).whereField(FirestoreConstants.id, isEqualTo: self.id as Any).whereField(FirestoreConstants.email, isEqualTo: Auth.auth().currentUser?.email as Any).getDocuments { snapshot, error in
            if let error{
                print("Error getting documents: \(error)")
            }else{
                if !snapshot!.documents.isEmpty {
                    print("Movie saved in the database already.")
                }else{
                    Firestore.firestore().collection(FirestoreConstants.collectionName).document(uuid).setData(docData){ error in
                        if let error {
                            print("Error writing document: \(error)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Helpers
extension DetailViewController : UIScrollViewDelegate {
    private func trimTextForLabel(_ label: UILabel, maxLength: Int) {
        if let originalText = label.text, originalText.count > maxLength {
            let index = originalText.index(originalText.startIndex, offsetBy: maxLength)
            let trimmedText = originalText.prefix(upTo: index) + "..."
            label.text = String(trimmedText)
        }
    }
    private func style() {
        scrollView.backgroundColor = .secondarySystemBackground
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        labelStackView = UIStackView(arrangedSubviews: [movieNameLabel, movieYearLabel])
        labelStackView.axis = .horizontal
        labelStackView.spacing = 12
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        moviePosterView.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        movieYearLabel.translatesAutoresizingMaskIntoConstraints = false
        movieAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trailerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.backgroundColor = .secondarySystemBackground
        detailCollectionView.layer.borderWidth = 1
        detailCollectionView.isScrollEnabled = true
        detailCollectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.identifier)
        detailCollectionView.register(DetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier)
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.backgroundColor = .secondarySystemBackground
        castCollectionView.layer.borderWidth = 1
        castCollectionView.isScrollEnabled = true
        castCollectionView.register(CreditsCell.self, forCellWithReuseIdentifier: CreditsCell.identifier)
        castCollectionView.register(DetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier)
        
        trailerCollectionView.delegate = self
        trailerCollectionView.dataSource = self
        trailerCollectionView.backgroundColor = .secondarySystemBackground
        trailerCollectionView.layer.borderWidth = 4
        trailerCollectionView.isScrollEnabled = true
        trailerCollectionView.register(TrailerCell.self, forCellWithReuseIdentifier: TrailerCell.identifier)
        trailerCollectionView.register(DetailSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailSectionHeader.identifier)
        
    }
    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(moviePosterView)
        scrollView.addSubview(labelStackView)
        scrollView.addSubview(movieAverageLabel)
        scrollView.addSubview(favoriteButton)
        scrollView.addSubview(movieOverviewLabel)
        scrollView.addSubview(castCollectionView)
        scrollView.addSubview(trailerCollectionView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            moviePosterView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            moviePosterView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            moviePosterView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            moviePosterView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 3/7),
            moviePosterView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            labelStackView.topAnchor.constraint(equalTo: moviePosterView.bottomAnchor, constant: 16),
            labelStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant:  -12),
            
            movieAverageLabel.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 16),
            movieAverageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            movieAverageLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            favoriteButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 120),
            favoriteButton.bottomAnchor.constraint(equalTo: movieOverviewLabel.topAnchor, constant: -10),
            favoriteButton.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 16),
            
            movieOverviewLabel.topAnchor.constraint(equalTo: movieAverageLabel.bottomAnchor, constant: 10),
            movieOverviewLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            movieOverviewLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            castCollectionView.topAnchor.constraint(equalTo: movieOverviewLabel.bottomAnchor, constant: 20),
            castCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            castCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            castCollectionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 3/7),
            
            trailerCollectionView.topAnchor.constraint(equalTo: castCollectionView.bottomAnchor, constant: 20),
            trailerCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            trailerCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            trailerCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            trailerCollectionView.heightAnchor.constraint(equalToConstant: 240),
            
        ])
    }
}
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView {
            return casts?.count ?? 0
        } else if collectionView == trailerCollectionView {
            return videoData?.count ?? 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditsCell.identifier, for: indexPath) as? CreditsCell else {
                return UICollectionViewCell()
            }
            let cast = casts?[indexPath.item]
            cell.configure(with: cast)
            return cell

        } else if collectionView == trailerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCell.identifier, for: indexPath) as? TrailerCell else {
                return UICollectionViewCell()
            }
            let video = videoData?[indexPath.item]
            cell.configure(with: video)
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-22.5)
        if collectionView == castCollectionView {
            return CGSize(width: width / 2.25, height: width / 1.333)
        } else if collectionView == trailerCollectionView {
            return CGSize(width: width / 1.333, height: 240)
        }
        return CGSize(width: 50, height: 50)
    }
}
