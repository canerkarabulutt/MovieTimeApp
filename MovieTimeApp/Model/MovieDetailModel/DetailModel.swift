//
//  DetailModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation

//MARK: - DetailMovieModel
struct DetailMovieModel {
    let movieTitle: String
    let posterURL: String
    let overview: String
    let releaseDate: String
    let id : Int
    let voteAverage: Double
    let voteCount: Int
    let genre : String
    let popularity : Double
    
    var score : String {
        return String(format:"⭐️ %.1f / 10", voteAverage) + " (\(String(voteCount)))"
    }
    
    var posterImage : URL? {
        return URL(string: "\(MovieConstants.baseImageURL)\(String(describing: posterURL))")
    }
    
    var dateAndGenre : String {
        return "\(releaseDate.dropLast(6))" + " | " + "\(genre.dropLast(2))"
    }
    var popular : String {
        return String(format: "%.1f", popularity)
    }
     
}

