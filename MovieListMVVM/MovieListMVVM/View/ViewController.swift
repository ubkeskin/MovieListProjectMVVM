//
//  ViewController.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
  
  enum Section {
    case main
  }
  
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
    self.view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
    ])
  }
  private func bindViewModel() {
    self.viewModel.fetchMovies()
    
    viewModel.$movies
      .receive(on: DispatchQueue.main)
      .sink { movies in
        self.collectionView.reloadData()
      }
      .store(in: &cancellables)
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
    cell.movieName.text = viewModel.movies[indexPath.row].title
    cell.poster.image = UIImage(systemName: "film")
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

