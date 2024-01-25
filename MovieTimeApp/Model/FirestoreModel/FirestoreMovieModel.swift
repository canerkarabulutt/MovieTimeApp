//
//  FirestoreMovieModel.swift
//  MovieApp
//
//  Created by Caner Karabulut on 22.01.2024.
//

import Foundation

//MARK: - FireStoreMovieModel
struct FireStoreMovieModel {
    var id : Int?
    var movieID : String
    var posterURL : String
    var title : String
    var date : String
    var overview : String
    var score : String
    var uuid : String
    
    init(id: Int? = nil, movieID:String, posterURL : String, title: String, date: String, overview: String, score: String, uuid: String) {
        self.id = id
        self.movieID = movieID
        self.posterURL = posterURL
        self.title = title
        self.date = date
        self.overview = overview
        self.score = score
        self.uuid = uuid
    }
}
