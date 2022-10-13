//
//  MovieDBJSONClient.swift
//  MovieListMVVM
//
//  Created by OS on 12.10.2022.
//

import Foundation

protocol MovieDBJSONClient {
  typealias TheMovieDBJSONCompletionHandler = (Result<[String:Any]>) -> ()

  static func handle(result: Result<Any>, completionHandler: TheMovieDBJSONCompletionHandler)
  static func handleSuccess(json: Any, completionHandler: TheMovieDBJSONCompletionHandler)
  static func handleFailure(for: Error, completionHandle: TheMovieDBJSONCompletionHandler)
}

extension MovieDBJSONClient {
    static func handle(result: Result<Any>, completionHandler: TheMovieDBJSONCompletionHandler) {
      switch result {
        case .success(let json):
          self.handleSuccess(json: json, completionHandler: completionHandler)
        case .failure(let error):
          self.handleFailure(for: error, completionHandle: completionHandler)
      }
    }
    static func handleSuccess(json: Any, completionHandler: TheMovieDBJSONCompletionHandler) {
      guard let json = json as? [String: Any] else {
        let error = NSError(domain: "badJSON", code: 1)
        handleFailure(for: error, completionHandle: completionHandler)
        return
      }
      completionHandler(Result.success(json))
  }
  static func handleFailure(for error: Error, completionHandle: TheMovieDBJSONCompletionHandler) {
    completionHandle(Result.failure(error))
  }
}

