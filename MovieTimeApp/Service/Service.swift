//
//  Service.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation

//MARK: - MovieConstants
struct MovieConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let type = "movie"
    static let apiKey = "api_key=d972d8951a87b367ae91ef00b5c90010"
    static let firstPage = "page=1"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    static let tv = "tv"
    static let day = "day"
    static let person = "person"
    
    struct Category {
        static let nowPlaying = "now_playing"
        static let popular = "popular"
        static let topRated = "top_rated"
        static let upcoming = "upcoming"
        static let trendingMovies = "trending"
        static let trendingTvs = "trending"
    }
}
//MARK: - URL Address
struct URLAddress {
    let urlNowPlaying = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(MovieConstants.Category.nowPlaying)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let urlPopular = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(MovieConstants.Category.popular)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let urlTopRated = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(MovieConstants.Category.topRated)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let urlTrendingTvs = "\(MovieConstants.baseURL)/\(MovieConstants.Category.trendingTvs)/\(MovieConstants.tv)/\(MovieConstants.day)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let urlTrendingMovies = "\(MovieConstants.baseURL)/\(MovieConstants.Category.trendingMovies)/\(MovieConstants.type)/\(MovieConstants.day)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let urlUpcoming =
    "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(MovieConstants.Category.upcoming)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let discoverURL = "\(MovieConstants.baseURL)/discover/\(MovieConstants.type)?\(MovieConstants.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&\(MovieConstants.firstPage)&with_watch_monetization_types=flatrate"
    let discoverTvURL = "\(MovieConstants.baseURL)/discover/\(MovieConstants.tv)?\(MovieConstants.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&\(MovieConstants.firstPage)&with_watch_monetization_types=flatrate"
    let searchQueryURL = "\(MovieConstants.baseURL)/search/\(MovieConstants.type)?\(MovieConstants.apiKey)&query="
    let genreData = "\(MovieConstants.baseURL)/genre/\(MovieConstants.type)/list?\(MovieConstants.apiKey)&language=en-US"
}
