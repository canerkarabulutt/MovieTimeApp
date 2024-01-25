//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation
import UIKit

struct DetailViewModel: Hashable, Equatable {
    public let movieTitle: String
    private let moviePosterPath: String?
    public let movieOverview: String?
    public let movieReleaseDate: String
    public let movieId: Int
    public let movieVoteAverage: Double
    public let movieVoteCount: Int
    public let movieGenre: String
    
    init(movieTitle: String, moviePosterPath: String?, movieOverview: String?, movieReleaseDate: String, movieId: Int, movieVoteAverage: Double,movieVoteCount: Int, movieGenre: String) {
        self.movieTitle = movieTitle
        self.moviePosterPath = moviePosterPath
        self.movieOverview = movieOverview
        self.movieReleaseDate = movieReleaseDate
        self.movieId = movieId
        self.movieVoteAverage = movieVoteAverage
        self.movieVoteCount = movieVoteCount
        self.movieGenre = movieGenre
    }
    public var moviePosterUrl: URL? {
        guard let posterPath = moviePosterPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500/" + posterPath)
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = moviePosterUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageLoader.shared.downloadImage(url, completion: completion)
    }
    var dateAndGenre : String {
        return "\(movieReleaseDate.dropLast(6))" + " | " + "\(movieGenre.dropLast(2))"
    }
    // MARK: - Equatable
    static func == (lhs: DetailViewModel, rhs: DetailViewModel) -> Bool {
        return lhs.movieTitle == rhs.movieTitle &&
               lhs.moviePosterPath == rhs.moviePosterPath &&
               lhs.movieOverview == rhs.movieOverview &&
               lhs.movieReleaseDate == rhs.movieReleaseDate &&
               lhs.movieId == rhs.movieId &&
               lhs.movieVoteAverage == rhs.movieVoteAverage &&
               lhs.movieVoteCount == rhs.movieVoteCount &&
               lhs.movieGenre == rhs.movieGenre
    }
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieTitle)
        hasher.combine(moviePosterPath)
        hasher.combine(movieOverview)
        hasher.combine(movieReleaseDate)
        hasher.combine(movieId)
        hasher.combine(movieVoteAverage)
        hasher.combine(movieVoteCount)
        hasher.combine(movieGenre)
    }
}
