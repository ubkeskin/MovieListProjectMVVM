//
//  MovieDBJSONClient.swift
//  MovieListMVVM
//
//  Created by OS on 12.10.2022.
//

import Foundation
typealias TheMovieDBJSONCompletionHandler = (Result<Data>) -> ()

protocol MovieDBJSONClient {

  static func handle(result: Result<Any>, completionHandler: TheMovieDBJSONCompletionHandler)
  static func handleSuccess(data: Data?, completionHandler: TheMovieDBJSONCompletionHandler)
  static func handleFailure(for: Error, completionHandle: TheMovieDBJSONCompletionHandler)
}

extension MovieDBJSONClient {
    static func handle(result: Result<Any>, completionHandler: TheMovieDBJSONCompletionHandler) {
      switch result {
        case .success(let data):
          self.handleSuccess(data: data as? Data, completionHandler: completionHandler)
        case .failure(let error):
          self.handleFailure(for: error, completionHandle: completionHandler)
      }
    }
    static func handleSuccess(data: Data?, completionHandler: TheMovieDBJSONCompletionHandler) {
      guard let data = data else {
        let error = NSError(domain: "badData", code: 1)
        handleFailure(for: error, completionHandle: completionHandler)
        return
      }
      completionHandler(Result.success(data))
  }
  static func handleFailure(for error: Error, completionHandle: TheMovieDBJSONCompletionHandler) {
    completionHandle(Result.failure(error))
  }
}

