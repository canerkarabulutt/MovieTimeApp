//
//  SearchCollectionViewCellViewModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 23.12.2023.
//

import Foundation
import UIKit

struct SearchCollectionViewCellViewModel: Hashable, Equatable {
    public let movieTitle: String
    private let movieCount: Int
    private let movieVoteAverage: Double
    private let moviePosterPath: String?

    init(movieTitle: String, movieCount: Int, movieVoteAverage: Double, moviePosterPath: String?) {
        self.movieTitle = movieTitle
        self.movieCount = movieCount
        self.movieVoteAverage = movieVoteAverage
        self.moviePosterPath = moviePosterPath
    }
    public var movieCountText: String {
        return "Views : \(movieCount)"
    }
    public var movieVoteAverageText: String {

        return "Rate :  ⭐️\(movieVoteAverage) / 10"
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

    // MARK: - Equatable
    static func == (lhs: SearchCollectionViewCellViewModel, rhs: SearchCollectionViewCellViewModel) -> Bool {
        return lhs.movieTitle == rhs.movieTitle &&
               lhs.movieVoteAverage == rhs.movieVoteAverage &&
               lhs.moviePosterPath == rhs.moviePosterPath &&
               lhs.movieCount == rhs.movieCount
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieTitle)
        hasher.combine(movieCount)
        hasher.combine(movieVoteAverage)
        hasher.combine(moviePosterPath)
    }
}
