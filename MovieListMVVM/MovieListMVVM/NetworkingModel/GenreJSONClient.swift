//
//  GenreJSONClient.swift
//  MovieListMVVM
//
//  Created by OS on 17.10.2022.
//

import Foundation

enum GenreJSONClient: MovieDBJSONClient {
  
  static func fetchMovie(for section: Section, completion: @escaping TheMovieDBJSONCompletionHandler) {
    JSONClient.makeAPICall(to: Genre.movie(section: section)) { result in
      self.handle(result: result, completionHandler: completion)
    }
  }
  static func fetchTV(for section: Section, completion: @escaping TheMovieDBJSONCompletionHandler) {
    JSONClient.makeAPICall(to: Genre.tv(section: section)) { result in
      self.handle(result: result, completionHandler: completion)
    }
  }
}
