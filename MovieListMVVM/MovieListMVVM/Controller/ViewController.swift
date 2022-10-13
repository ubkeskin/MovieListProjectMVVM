//
//  ViewController.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Combine
import UIKit

class ViewController: UIViewController {
  var viewModel = ViewModel()
  
  private var cancellables: Set<AnyCancellable> = []
  private lazy var collectionView: UICollectionView = {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    ])
  }

  private func bindViewModel() {
    viewModel.fetchMovies()
    
    viewModel.$movies
      .receive(on: DispatchQueue.main)
      .sink { _ in
        self.collectionView.reloadData()
      }
      .store(in: &cancellables)
  }
  
  private func loadPosterImage(movie: MovieResult, completion: @escaping (UIImage) -> Void) {
    guard let url = viewModel.apiManager?.getMovieURL(dataResult: movie) else { return completion(UIImage(systemName: "film")!) }
    var image = UIImage(systemName: "film")!
    viewModel.apiManager?.loadImage(url: url, completion: { data, _ in
      DispatchQueue.main.async {
        image = UIImage(data: data!)!
        completion(image)
      }
    })
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.movies.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var image = UIImage()
    let url = viewModel.apiManager?.getMovieURL(dataResult: viewModel.movies[indexPath.row])
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
    cell.movieName.text = viewModel.movies[indexPath.row].title
    cell.popularityLabel.text = String(describing: viewModel.movies[indexPath.row].popularity)
    cell.ratingLabel.text = String(describing: viewModel.movies[indexPath.row].voteAverage)
    cell.releaseDateLabel.text = viewModel.movies[indexPath.row].releaseDate
    DispatchQueue.main.async {
      self.viewModel.apiManager?.loadImage(url: url!, completion: { _, _ in
        self.loadPosterImage(movie: self.viewModel.movies[indexPath.row]) { image in
          cell.poster.image = image
        }
      })
    }
    return cell
  }
  
  private func collectionViewLayout() -> UICollectionViewLayout {
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
    
    return layout
  }
}
