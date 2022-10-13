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
//
//  TVShowDataModel.swift
//  Solid_ICT Movie App
//
//  Created by OS on 1.10.2022.
//

import Foundation

// MARK: - MovieModal

struct TVShowsModel: Codable {
  let page: Int?
  let results: [TVShowsResult]?
  let totalResults, totalPages: Int?
  let dates: Dates?
  
  enum CodingKeys: String, CodingKey {
    case results, page, dates
    case totalResults = "total_results"
    case totalPages = "total_pages"
  }
}

// MARK: TV Show Data Model

struct TVShowsResult: Codable {
  let posterPath: String?
  let popularity: Double
  let id: Int
  let backdropPath: String?
  let voteAverage: Double
  let overview: String
  let firstAirDate: String
  let originCountry: [String]
  let genreIDs: [Int]
  let originalLanguage: String
  let voteCount: Int
  let name: String
  let originalName: String
  
  enum CodingKeys: String, CodingKey {
    case popularity, id, overview, name
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
    case voteAverage = "vote_average"
    case firstAirDate = "first_air_date"
    case originCountry = "origin_country"
    case genreIDs = "genre_ids"
    case originalLanguage = "original_language"
    case voteCount = "vote_count"
    case originalName = "original_name"
  }
}

