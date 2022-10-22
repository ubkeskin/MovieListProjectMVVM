//
//  ViewController.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Combine
import UIKit

protocol ViewControllerInterface: AnyObject {
  var tabBarControllerSelectedIndex: Int { get }
  var collectionView: UICollectionView { get }
  var content: UIView { get }
  
  func setCollectionViewCell(for cell: CollectionViewCell, indexPath: IndexPath)
}

extension LibraryViewController: ViewControllerInterface {

  var content: UIView {
    self.view
  }
  var collectionView: UICollectionView {
    get {
      (viewModel?.setCollectionView())!
    }
  }
  
  var tabBarControllerSelectedIndex: Int {
    guard let tabBarControllerSelectedIndex = tabBarController?.selectedIndex else  { return 0 }
    return tabBarControllerSelectedIndex
  }

  func setCollectionViewCell(for cell: CollectionViewCell, indexPath: IndexPath) {
    switch viewModel?.genre {
      case .movie(section: _):
        let url = viewModel?.getPosterUrl(indexPath: indexPath.row)
        cell.movieName.text = (viewModel?[safe: indexPath.row] as! MovieResult).title
        cell.popularityLabel.text = String(describing: (viewModel?[safe: indexPath.row] as! MovieResult).popularity)
        cell.ratingLabel.text = String(describing: (viewModel?[safe: indexPath.row] as! MovieResult).voteAverage)
        cell.releaseDateLabel.text = (viewModel?[safe: indexPath.row] as! MovieResult).releaseDate
        DispatchQueue.main.async { [self] in
          viewModel?.apiManager?.loadImage(url: url!, completion: {[self] _, _ in
            viewModel?.apiManager.loadPosterImage(genre: viewModel!.genre, dataResult: viewModel?[safe: indexPath.row] as Any) { image in
              cell.poster.image = image }
          })
        }
      case .tv(section: _):
        let url = viewModel?.getPosterUrl(indexPath: indexPath.row)
        cell.movieName.text = (viewModel?[safe: indexPath.row] as! TVShowsResult ).name
        cell.popularityLabel.text = String(describing: (viewModel?[safe: indexPath.row] as! TVShowsResult ).popularity)
        cell.ratingLabel.text = String(describing: (viewModel?[safe: indexPath.row] as! TVShowsResult ).voteAverage)
        cell.releaseDateLabel.text = (viewModel?[safe: indexPath.row] as! TVShowsResult ).firstAirDate
        DispatchQueue.main.async { [self] in
          viewModel?.apiManager?.loadImage(url: url!, completion: {[self] _, _ in
            viewModel?.apiManager.loadPosterImage(genre: viewModel!.genre, dataResult: (viewModel?[safe: indexPath.row]) as Any ) { image in
              cell.poster.image = image }
          })
        }
      case .none:
        return
    }
  }


  @objc func setSelectedSection(sender: UISegmentedControl) {
    if tabBarControllerSelectedIndex == 0 {
      if sender.selectedSegmentIndex == 0 {
        viewModel?.section = .popular
      } else if sender.selectedSegmentIndex == 1 {
        viewModel?.section = .topRated
      } else if sender.selectedSegmentIndex == 2 {
        viewModel?.section = .nowPlaying
      }
    } else {
      if sender.selectedSegmentIndex == 0 {
        viewModel?.section = .popular
      }
      if sender.selectedSegmentIndex == 1 {
        viewModel?.section = .topRated
      }
    }
    viewModel?.bindViewController()
  }
}

// TODO: Create protocol ViewController, and use it in view model.
class LibraryViewController: UIViewController {
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
      switch viewModel?.genre {
        case .tv:
          headerView.genre = .tv(section: viewModel!.section)
        case .movie:
          headerView.genre = .movie(section: viewModel!.section)
        case .none:
          fatalError()
      }
      headerView.segmentControl.addTarget(self, action: #selector(setSelectedSection), for: .allEvents)
    }
    return headerView
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch viewModel?.genre {
      case .movie(section: _):
        return (viewModel?.movies.count)!
      case .tv(section: _):
        return (viewModel?.tvResult.count)!
      case .none:
        return 0
    }
    
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
