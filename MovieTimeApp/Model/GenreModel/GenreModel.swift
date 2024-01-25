//
//  GenreModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation

// MARK: - MovieGenreData
struct GenreData : Codable {
    let genres: [Genre]?
}
// MARK: - Genre
struct Genre : Codable {
    let id: Int?
    let name: String?
}

