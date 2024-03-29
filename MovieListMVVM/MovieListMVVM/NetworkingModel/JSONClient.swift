//
//  JSONClient.swift
//  MovieListMVVM
//
//  Created by OS on 12.10.2022.
//

import Foundation


enum JSONClient {
  typealias JSONCompletionHandler = (Result<Any>) -> ()
  static func makeAPICall(to endpoint: GenreEndpoint, completionHandler: @escaping JSONCompletionHandler) {
    APIManager().request(endpoint: endpoint) { response in
      switch response {
        case .success(let response):
          completionHandler(Result.success(response))
        case .failure(let error):
          completionHandler(Result.failure(error))
      }
    }
  }
}
