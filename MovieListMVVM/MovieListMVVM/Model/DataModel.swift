//
//  MoviesModel.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Foundation

// MARK: - MovieModal

struct MoviesData: Codable {
  let page: Int?
  let results: [MovieResult]?
  let totalResults, totalPages: Int?
  let dates: Dates?
  
  enum CodingKeys: String, CodingKey {
    case results, page, dates
    case totalResults = "total_results"
    case totalPages = "total_pages"
  }
}

// MARK: - Movie Result

struct MovieResult: Codable, Hashable {
  let adult: Bool
  let backdropPath: String?
  let genreIDS: [Int]
  let id: Int
  let originalLanguage: String
  let originalTitle, overview: String
  let popularity: Double
  let posterPath: String?
  let releaseDate, title: String
  let video: Bool
  let voteAverage: Double
  let voteCount: Int
  
  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case genreIDS = "genre_ids"
    case id
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview, popularity
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case title, video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
}

struct Dates: Codable {
  let maximum: String
  let minimum: String
}
