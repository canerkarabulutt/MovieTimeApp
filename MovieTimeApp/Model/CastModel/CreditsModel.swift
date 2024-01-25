//
//  CreditsModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation

// MARK: - Credits
struct CreditsData : Codable {
    let id: Int?
    let cast, crew: [Cast]?
}
// MARK: - Cast
struct Cast : Codable {
    let adult: Bool?
    let gender, id: Int?
    let known_for_department, name, original_name: String?
    let popularity: Double?
    let profile_path: String?
    let cast_id: Int?
    let character, credit_id: String?
    let order: Int?
    let department, job: String?
}
