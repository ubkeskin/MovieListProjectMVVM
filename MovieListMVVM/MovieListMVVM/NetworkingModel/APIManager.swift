//
//  APIManager.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import UIKit
import Kingfisher


class APIManager {
  
  static var decoder = JSONDecoder()

  func request(endpoint: GenreEndpoint,
               completionHandler: @escaping (Result<Any>) -> ()) {
    
    var urlComponents = URLComponents(string: endpoint.url.description)
    urlComponents?.queryItems = endpoint.parameters.map({ (key: String, value: String) in
      URLQueryItem(name: key, value: value)
    }).sorted(by: { item1, item2 in
      item1.value!.count > item2.value!.count
    })
    var request = URLRequest(url: (urlComponents?.url)!)
    request.httpMethod = endpoint.method
    print(request)
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
          completionHandler(Result.failure(NSError(domain: "", code: 0)))
        }
        return
      }
        completionHandler(Result.success(data))
    }
    task.resume()
  }

  func loadImage(genre: Genre, dataResult: Any, completion: @escaping (Result<UIImage>) -> Void) {
    let url = getMovieURL(genre: genre, dataResult: dataResult)
    downloadImage(with: url, completion: completion)
  }
  
  func downloadImage(with url: URL, completion: @escaping (Result<UIImage>) -> Void) {
    let image = UIImageView()
    image.kf.setImage(with: url) { result in
      switch result {
        case .success(let image):
          completion(Result.success(image.image))
        case .failure(let error):
          completion(Result.failure(NSError(domain: error.localizedDescription, code: 0)))
      }
    }
  }
  func getMovieURL(genre: Genre, dataResult: Any) -> URL {
    switch genre {
      case .movie(section: _):
        guard let dataResult = dataResult as? MovieResult else { fatalError()}
        let placeHolderImagePath = URL(string: "https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg")!
        guard let path = dataResult.posterPath else { return placeHolderImagePath }
        let host = "https://image.tmdb.org/t/p/w500"
        guard let url = URL(string: host + path) else {
          fatalError("did not get url")
        }
        return url
      case .tv(section: _):
        guard let dataResult = dataResult as? TVShowsResult else { fatalError() }
        let placeHolderImagePath = URL(string: "https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg")!
        guard let path = dataResult.posterPath else { return placeHolderImagePath }
        let host = "https://image.tmdb.org/t/p/w500"
        guard let url = URL(string: host + path) else {
          fatalError("did not get url")
        }
        return url
    }
  }
}
