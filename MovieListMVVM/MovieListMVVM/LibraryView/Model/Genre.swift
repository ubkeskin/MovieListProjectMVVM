//
//  Genre.swift
//  MovieListMVVM
//
//  Created by OS on 13.10.2022.
//

import Foundation
enum Section {
  case topRated, popular, nowPlaying
}
enum Genre {
  case tv(section: Section), movie(section: Section)
}

extension Genre: Endpoint {
  func provideValues() -> (url: URL, method: String, parameters: [String : String]) {
    let method = "GET"
    let parameters = ["api_key":"23a23e89a3ba0b461401eb64ff2afcdb", "language":"en-US", "page": "\(Int.random(in: 1...100))" ]
    var url: URL? {
      var url: URL?
      switch self {
        case .movie(section: .topRated):
          url = URL(string: "https://api.themoviedb.org/3/movie/top_rated")
        case .movie(.popular):
          url = URL(string: "https://api.themoviedb.org/3/movie/popular")
        case .movie(.nowPlaying):
          url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")
        case .tv(.topRated):
          url = URL(string: "https://api.themoviedb.org/3/tv/top_rated")
        case .tv(.popular):
          url = URL(string: "https://api.themoviedb.org/3/movie/popular")
        case .tv(section: .nowPlaying):
          fatalError()
      }
      return url
    }
    return (url: url!, method: method, parameters: parameters)
  }
}
