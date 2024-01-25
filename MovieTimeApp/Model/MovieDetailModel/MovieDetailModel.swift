//
//  MovieDetailModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation

//MARK: - MovieDetailsData
struct MovieDetailsData : Codable{
    let id: Int?
    let imdb_id, homepage: String?
    let original_title, overview: String?
    let title: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let vote_average: Double?
    let vote_count: Int?
}

