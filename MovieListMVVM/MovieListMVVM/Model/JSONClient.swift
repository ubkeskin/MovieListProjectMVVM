//
//  JSONClient.swift
//  MovieListMVVM
//
//  Created by OS on 12.10.2022.
//

import Foundation


enum JSONClient: MovieDBJSONClient {
  typealias JSONCompletionHandler = (Result<Any>) -> ()
  static func makeAPICall(to endpoint: Endpoint, completionHandler: @escaping JSONCompletionHandler) {
    APIManager().request(url: endpoint.url, method: endpoint.method, parameters: endpoint.parameters) { response in
      switch response {
        case .success(let response): completionHandler(Result.success(response))
        case .failure(let error): completionHandler(Result.failure(error))
      }
    }
  }
}
