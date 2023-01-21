//
//  ViewModel.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Combine
import Foundation

protocol ViewModelInterface {
  func setSelectedSection(index: Int)
  func viewDidLoad()
  func setCollectionCell(for cell: CollectionViewCell, indexPath: IndexPath)
  func getPosterUrl(indexPath: Int) -> URL
  }
extension ViewModel: ViewModelInterface {
  func setCollectionCell(for cell: CollectionViewCell, indexPath: IndexPath) {
    switch genre {
      case .movie(section: _):
        let movie = movies[indexPath.row]
        cell.movieName.text = movie.title
        cell.popularityLabel.text = String(describing: movie.popularity)
        cell.ratingLabel.text = String(describing: movie.voteAverage)
        cell.releaseDateLabel.text = movie.releaseDate
        DispatchQueue.main.async { [self] in
          apiManager?.loadImage(genre: genre, dataResult: movie, completion: { result in
            switch result {
              case .success(let image):
                cell.poster.image = image
              case .failure(let error):
                print(error)
            }
          })
        }
      case .tv(section: _):
        let tvShow = tvResult[indexPath.row]
        cell.movieName.text = tvShow.name
        cell.popularityLabel.text = String(describing: tvShow.popularity)
        cell.ratingLabel.text = String(describing: tvShow.voteAverage)
        cell.releaseDateLabel.text =  tvShow.firstAirDate
        DispatchQueue.main.async { [self] in
          apiManager?.loadImage(genre: genre, dataResult: tvShow, completion: { result in
            switch result {
              case .success(let image):
                cell.poster.image = image
              case .failure(let error):
                print(error)
          }
        })
      }
    }
  }
  func setSelectedSection(index: Int) {
    if view?.tabBarControllerSelectedIndex == 0 {
      if index == 0 {
        section = .popular
      } else if index == 1 {
        section = .topRated
      } else if index == 2 {
        section = .nowPlaying
      }
    } else {
      if index == 0 {
        section = .popular
      }
      if index == 1 {
        section = .topRated
      }
    }
    view?.bindViewController()
  }
  func getPosterUrl(indexPath: Int) -> URL {
    switch genre{
      case .movie(section: _):
        return self.apiManager.getMovieURL(genre: genre, dataResult: movies[indexPath])
      case .tv(section: _):
        return self.apiManager.getMovieURL(genre: genre, dataResult: tvResult[indexPath])
    }
  }
  func viewDidLoad() {
    view?.bindViewController()
    view?.setCollectionView()
  }
// TODO read Beyzas link.
  subscript(safe index: Int) -> Any {
    switch genre {
      case .movie(section: _):
        return movies.indices.contains(index) ? movies[index] : nil
      case .tv(section: _):
        return tvResult.indices.contains(index) ? tvResult[index] : nil
    }
  }
}
class ViewModel {
  weak var view: (ViewControllerInterface)?
  var apiManager: APIManager!
  var decoder = JSONDecoder()
  var movies: [MovieResult] = []
  var tvResult: [TVShowsResult] = []
  var genre: Genre {
    if view?.tabBarControllerSelectedIndex == 0 {
      return .movie(section: section)
    } else {
      return .tv(section: section)
    }
  }
  var section: Section
  init(view: ViewControllerInterface) {
    self.apiManager = APIManager()
    self.view = view
    self.section = .popular
  }
  func fetchMovie(section: Section, completion: @escaping () -> Void) {
    GenreJSONClient.fetchMovie(for: section) { [self] results in
      switch results {
        case .success(let successValue):
          let results = try? decoder.decode(MoviesData.self, from: successValue)
          movies = results?.results ?? []
          completion()
        case .failure(let error):
          print(error.localizedDescription)
      }
    }
  }
  func fetchTV(section: Section, completion: @escaping () -> Void) {
    GenreJSONClient.fetchTV(for: section) {[self] results in
      switch results {
        case .success(let successValue):
          let results = try? decoder.decode(TVShowsModel.self, from: successValue)
          tvResult = results?.results ?? []
          completion()
        case .failure(let error):
          print(error.localizedDescription)
      }
    }
  }
}
