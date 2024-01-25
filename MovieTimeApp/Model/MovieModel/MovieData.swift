//
//  MovieData.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation

// MARK: - MovieDataModel
struct MovieData: Codable {
    let results: [Movie]?
}
// MARK: - MovieResult
struct Movie: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let id: Int?
    let genre_ids : [Int]?
    let original_title, overview: String?
    let popularity: Double?
    let poster_path, release_date, title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
}

