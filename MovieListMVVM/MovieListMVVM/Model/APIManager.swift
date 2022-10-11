//
//  APIManager.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Foundation

class APIManager {
  static var decoder = JSONDecoder()
  
  func getMoviesData(successHandler: @escaping (MoviesData) -> Void, errorHandler: @escaping (Error) -> Void) {
    var urlQuery: String {
      var urlQuery = "top_rated"
      // TODO: add query possibilities.
      return urlQuery
    }
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.themoviedb.org"
    urlComponents.path = "/3/movie/" + "\(urlQuery)"
    urlComponents.queryItems = [
      URLQueryItem(name: "api_key", value: "23a23e89a3ba0b461401eb64ff2afcdb"),
      URLQueryItem(name: "page", value: "1"),
      URLQueryItem(name: "region", value: "DE")
    ]
    
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("error took place \(error)")
      }
      guard let httpResponse = response as? HTTPURLResponse,
            (200 ..< 300).contains(httpResponse.statusCode)
      else {
        return
      }
      guard let data = data else {
        DispatchQueue.main.async {
          errorHandler(NSError(domain: "", code: 0, userInfo: nil))
        }
        return
      }
      let decoder = JSONDecoder()
      
      do {
        let mediaResponse = try decoder.decode(MoviesData.self, from: data)
        DispatchQueue.main.async {
          successHandler(mediaResponse)
        }
      }
      catch {
        print(error)
      }
    }
    task.resume()
  }
}
