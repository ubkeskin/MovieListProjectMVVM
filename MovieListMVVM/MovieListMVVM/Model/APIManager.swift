//
//  APIManager.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Foundation
import UIKit


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
  
  // make
  func loadPosterImage(genre: Genre, dataResult: Any, completion: @escaping (UIImage) -> Void) {
    let url = getMovieURL(genre: genre, dataResult: dataResult)
    var image = UIImage(systemName: "film")!
    loadImage(url: url, completion: { data, _ in
      DispatchQueue.main.async {
        image = UIImage(data: data!)!
        completion(image)
      }
    })
  }
  
  //TODO delete and integrate SPM ımage loader
  
  func downloadImage(_ url: URL, file: URL, completion: @escaping (Error?) -> Void) {
    let task = URLSession.shared.downloadTask(with: url) { tempUrl, _, error in
      guard let tempURL = tempUrl else {
        completion(error)
        return
      }
      do {
        // Remove any existing document at file
        if FileManager.default.fileExists(atPath: file.path) {
          try FileManager.default.removeItem(at: file)
        }
        
        // Copy the tempURL to file
        try FileManager.default.copyItem(
          at: tempURL,
          to: file
        )
        
        completion(nil)
      }
      
      // Handle potential file system errors
      catch let fileError {
        completion(fileError)
      }
    }
    task.resume()
  }

  // MARK: LOAD IMAGE TASK

  func loadImage(url: URL, completion: @escaping (Data?, Error?) -> Void) {
    // Compute a path to the URL in the cache
    let fileCachePath = FileManager.default.temporaryDirectory
      .appendingPathComponent(
        url.lastPathComponent,
        isDirectory: false
      )
    
    // If the image does not exist in the cache,
    // download the image to the cache
    downloadImage(url, file: fileCachePath) { error in
      let data = try? Data(contentsOf: fileCachePath)
      completion(data, error)
    }
    // If the image exists in the cache,
    // load the image from the cache and exit
    if let data = try? Data(contentsOf: fileCachePath) {
      completion(data, nil)
      return
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
