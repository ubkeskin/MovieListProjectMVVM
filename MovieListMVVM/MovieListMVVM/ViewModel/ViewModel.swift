//
//  ViewModel.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Combine
import Foundation

class ViewModel: ObservableObject, MovieDBJSONClient {
  var apiManager: APIManager!
  var decoder = JSONDecoder()
  @Published var movies: [MovieResult] = []
  @Published var tvResult: [TVShowsResult] = []
  

  init() {
    self.apiManager = APIManager()
  }
  

  func fetchMovies(genre: Genre, section: Section) {
    var endPoint = apiManager
    switch genre {
      case .tv:
        switch section {
          case .topRated:
            apiManager = APIManager()
            apiManager.provideValues(section: section, genre: genre)
            JSONClient.makeAPICall(to: apiManager) { data in
              self.handle
            }
          case .popular(coding: let coding):
            <#code#>
          case .nowPlaying(coding: let coding):
            <#code#>
        }
      case .movie(section: let section):
        <#code#>
    }
    
    getMoviesData(successHandler: { [weak self] movieData in
      self?.movies = movieData.results!
    }, errorHandler: { error in
      print("error occured", error)
    })
  }
}
