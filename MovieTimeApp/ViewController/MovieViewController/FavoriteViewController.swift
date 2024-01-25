//
//  FavoriteViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 21.12.2023.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseStorage
import FirebaseAuth

class FavoriteViewController: UIViewController {
    //MARK: - Properties
    var loadedMovies = [FireStoreMovieModel]()
    var viewModel : DetailMovieModel?
    private var movieArray : [Movie]? = [Movie]()
    private var genreData : [Genre]? = [Genre]()
    var email : String?
    
    private let favoriteTableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        loadMovies()
        fetchGenreData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let window = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let mainTabController = window.keyWindow?.rootViewController as! MainTabBarViewController
        mainTabController.viewControllers?[0].tabBarItem.badgeValue = nil
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoriteTableView.frame = view.bounds
    }
}
//MARK: - Methods
extension FavoriteViewController {
    //Fetch Movies From Firestore
    func loadMovies() {
        Firestore.firestore().collection(FirestoreConstants.collectionName).order(by: FirestoreConstants.uploadDate, descending: true).addSnapshotListener { querySnapshot, error in
            if let error {
                print(error)
            }else{
                if querySnapshot?.isEmpty != true && querySnapshot != nil {
                    self.loadedMovies.removeAll()
                    for doc in querySnapshot!.documents{
                        if let email = doc.get(FirestoreConstants.email) as? String,let id = doc.get(FirestoreConstants.id) as? Int?, let movieId = doc.get(FirestoreConstants.movieId) as? String, let title = doc.get(FirestoreConstants.title) as? String, let date = doc.get(FirestoreConstants.date) as? String, let score = doc.get(FirestoreConstants.score) as? String, let posterString = doc.get(FirestoreConstants.posterPath) as? String, let overview = doc.get(FirestoreConstants.overview) as? String, let uuid = doc.get(FirestoreConstants.uuid) as? String{
                            if email == Auth.auth().currentUser?.email{
                                self.email = email
                                self.loadedMovies.append(FireStoreMovieModel(id: id, movieID: movieId, posterURL: posterString, title: title, date: date, overview: overview, score: score, uuid: uuid))
                            }
                        }
                    }
                    self.favoriteTableView.reloadData()
                }
            }
        }
    }
    //Fetch Genre Data
    private func fetchGenreData(){
        MovieManager.shared.performRequest(type: GenreData.self, query: "", externalID: "", movieID: 0, movieIDSelection: .none, movieURL: .none) { results in
            switch results{
            case.success(let genres):
                self.genreData = genres.genres
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
//MARK: - Helpers
extension FavoriteViewController {
    
    private func style() {
        favoriteTableView.backgroundColor = .systemBackground
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.register(FavoriteMovieTableViewCell.self, forCellReuseIdentifier: FavoriteMovieTableViewCell.identifier)
        favoriteTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(favoriteTableView)
        
        NSLayoutConstraint.activate([
            favoriteTableView.topAnchor.constraint(equalTo: view.topAnchor),
            favoriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteTableView.dequeueReusableCell(withIdentifier: FavoriteMovieTableViewCell.identifier, for: indexPath) as? FavoriteMovieTableViewCell else {
            return UITableViewCell()
        }
        cell.movieNameLabel.text = loadedMovies[indexPath.row].title
        cell.movieVoteAverageLabel.text = loadedMovies[indexPath.row].score
        cell.movieDateLabel.text = loadedMovies[indexPath.row].date
        let posterURL = loadedMovies[indexPath.row].posterURL
        cell.movieImageView.kf.setImage(with: URL(string: posterURL))
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if self.email == Auth.auth().currentUser?.email{
                Firestore.firestore().collection(FirestoreConstants.collectionName).document(loadedMovies[indexPath.row].uuid).delete()
                loadedMovies.remove(at: indexPath.row)
                self.favoriteTableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    //MARK: - Did Select Row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let externalID = loadedMovies[indexPath.row].movieID
        print(loadedMovies[indexPath.row].uuid)
        
        MovieManager.shared.performRequest(type: ExternalIDMovieData.self, query: "", externalID: externalID, movieID: 0, movieIDSelection: .none, movieURL: .none) { result in
            switch result{
            case .success(let movie):
                DispatchQueue.main.async {
                    self.movieArray = movie.movie_results
                    let detailVC = DetailViewController()
                    detailVC.movieArray = self.movieArray
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

