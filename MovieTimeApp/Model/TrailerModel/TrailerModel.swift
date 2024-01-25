//
//  TrailerModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation

//MARK: - VideoData
struct VideoData : Codable {
    let results : [VideoResults]?
}
//MARK: - VideoResults
struct VideoResults : Codable {
    let key : String?
}

