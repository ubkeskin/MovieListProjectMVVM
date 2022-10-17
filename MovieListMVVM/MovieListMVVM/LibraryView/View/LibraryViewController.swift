//
//  ViewController.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Combine
import UIKit

protocol ViewControllerInterface: AnyObject {
  var genre: Genre { get }
  var section: Section { get set }
  var cancellables: Set<AnyCancellable> { get set }

  func setCollectionView()
  func bindViewController()
  func setCollectionViewCell(for cell: CollectionViewCell, indexPath: IndexPath)
}

extension LibraryViewController: ViewControllerInterface {
  func setCollectionViewCell(for cell: CollectionViewCell, indexPath: IndexPath) {
    let url = viewModel?.getPosterUrl(indexPath: indexPath.row)
    cell.movieName.text = viewModel?[indexPath.row].title
    cell.popularityLabel.text = String(describing: viewModel?[indexPath.row].popularity)
    cell.ratingLabel.text = String(describing: viewModel?[indexPath.row].voteAverage)
    cell.releaseDateLabel.text = viewModel?[indexPath.row].releaseDate
    DispatchQueue.main.async { [self] in
      viewModel?.apiManager?.loadImage(url: url!, completion: {[self] _, _ in
        viewModel?.apiManager.loadPosterImage(movie: (viewModel?[indexPath.row])!) { image in
          cell.poster.image = image
        }
      })
    }
  }
  
  var genre: Genre {
    if tabBarController?.selectedIndex == 0 {
      return .movie(section: section)
    } else {
      return .tv(section: section)
    }
  }
  var section: Section {
    get {
      .popular
    }
    set {}
  }
  var cancellables: Set<AnyCancellable> {
    get {
      []
    }
    set {}
  }
  func bindViewController() {
    viewModel?.fetchMovie(section: section, completion: { [self] in
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    })
   
  }

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

  func setCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    view.addSubview(collectionView)
    collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
    collectionView.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderView.reuseIdentity)
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    ])
  }

  @objc func setSelectedSection(sender: UISegmentedControl) {
    if tabBarController?.selectedIndex == 0 {
      if sender.selectedSegmentIndex == 0 {
        section = .popular
        
      } else if sender.selectedSegmentIndex == 1 {
        section = .topRated
      } else if sender.selectedSegmentIndex == 2 {
        section = .nowPlaying
      }
    } else {
      if sender.selectedSegmentIndex == 0 {
        section = .popular
      }
      if sender.selectedSegmentIndex == 1 {
        section = .topRated
      }
    }
    bindViewController()
  }
}

// TODO: Create protocol ViewController, and use it in view model.
class LibraryViewController: UIViewController {
  var collectionView: UICollectionView!
  // TODO: Create view mdel protocol
  var viewModel: ViewModel?
  
  // TODO: Change with a proper funcion
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = ViewModel(view: self)
    viewModel?.viewDidLoad()
  }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeaderView.reuseIdentity, for: indexPath) as! CollectionViewHeaderView

    if kind == UICollectionView.elementKindSectionHeader {
      switch genre {
        case .tv:
          headerView.genre = .tv(section: section)
        case .movie:
          headerView.genre = .movie(section: section)
      }
      headerView.segmentControl.addTarget(self, action: #selector(setSelectedSection), for: .allEvents)
    }
    return headerView
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    (viewModel?.movies.count)!
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // TODO: Store data in viewmodel.
    // TODO: Add get url function in Vİew Model Interface
    // TODO: change force as with optional
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell()}
    // TODO: Subscript extension !! NOTICE
    setCollectionViewCell(for: cell, indexPath: indexPath)
    return cell
  }
}
