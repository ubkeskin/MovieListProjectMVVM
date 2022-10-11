//
//  ViewModel.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
  private var apiManager: APIManager?
  @Published var movies: [MovieResult] = []
  
  init() {
    self.apiManager = APIManager()
  }
  
  func fetchMovies() {
    apiManager?.getMoviesData(successHandler: { [weak self] movieData in
      self?.movies = movieData.results!
    }, errorHandler: { (error) in
      print("error occured", error)
    })
  }
  
}
