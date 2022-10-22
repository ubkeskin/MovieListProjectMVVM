//
//  ViewModel.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Combine
import Foundation
import UIKit

protocol ViewModelInterface {
  func viewDidLoad()
  func getPosterUrl(indexPath: Int) -> URL
  func bindViewController()
  func setCollectionView() -> UICollectionView
  func collectionViewLayout() -> UICollectionViewLayout
  }
extension ViewModel: ViewModelInterface {
  func collectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    let cellWidthHeightConstant: CGFloat = UIScreen.main.bounds.width
    
    layout.sectionInset = UIEdgeInsets(top: 0,
                                       left: 10,
                                       bottom: 0,
                                       right: 10)
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.itemSize = CGSize(width: cellWidthHeightConstant, height: cellWidthHeightConstant)
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
    
    return layout
  }
  func setCollectionView() -> UICollectionView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    view!.content.addSubview(collectionView)
    collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
    collectionView.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderView.reuseIdentity)
    collectionView.backgroundColor = .white
    collectionView.delegate = view.self as? any UICollectionViewDelegate
    collectionView.dataSource = view.self as? any UICollectionViewDataSource
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view!.content.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view!.content.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: view!.content.safeAreaLayoutGuide.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view!.content.safeAreaLayoutGuide.rightAnchor)
    ])
    return collectionView
  }
  func bindViewController() {
    switch genre {
      case .movie(section: _):
        fetchMovie(section: section, completion: {
          DispatchQueue.main.async {[self] in
            view!.collectionView.reloadData()
          }
        })
      case .tv(section: _):
        fetchTV(section: section, completion: {
          DispatchQueue.main.async {[self] in
            view!.collectionView.reloadData()
          }
        })
    }
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
    bindViewController()
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
