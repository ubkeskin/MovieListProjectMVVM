//
//  ViewModel.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Combine
import Foundation

protocol ViewModelInterface {
  func viewDidLoad()
  func getPosterUrl(indexPath: Int) -> URL
}
extension ViewModel: ViewModelInterface {
  func getPosterUrl(indexPath: Int) -> URL {
    self.apiManager.getMovieURL(dataResult: movies[indexPath])
  }
  
  func viewDidLoad() {
    view?.setCollectionView()
    view?.bindViewController()
  }
  subscript(index: Int) -> MovieResult {
    movies[index]
  }
}

class ViewModel {
  weak var view: (ViewControllerInterface)?
  var apiManager: APIManager!
  var decoder = JSONDecoder()
  var movies: [MovieResult] = []
  var tvResult: [TVShowsResult] = []
  

  init(view: ViewControllerInterface) {
    self.apiManager = APIManager()
    self.view = view
  }
  
  func fetchMovie(section: Section, completion: @escaping () -> Void) {
    GenreJSONClient.fetchMovie(for: section) { [self] result in
      switch result {
        case .success(let successValue):
          let results = try? decoder.decode(MoviesData.self, from: successValue)
          movies = results?.results ?? []
          completion()
        case .failure(let error):
          print(error.localizedDescription)
      }
    }
  }
}
