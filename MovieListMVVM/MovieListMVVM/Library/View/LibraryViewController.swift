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
  
  func bindViewController()
  func setCollectionView()
}

extension LibraryViewController: ViewControllerInterface {

  var tabBarControllerSelectedIndex: Int {
    guard let tabBarControllerSelectedIndex = tabBarController?.selectedIndex else  { return 0 }
    return tabBarControllerSelectedIndex
  }
  func bindViewController() {
    switch viewModel?.genre {
      case .tv(section: let section):
        viewModel?.fetchTV(section: section!, completion: {
          DispatchQueue.main.async { [self] in
            collectionView.reloadData()
          }
        })
      case .movie(section: let section):
        viewModel?.fetchMovie(section: section!, completion: {
          DispatchQueue.main.async { [self] in
            collectionView.reloadData()
          }
        })
      case .none:
        fatalError()
        
    }
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
  func setCollectionViewCell(for cell: CollectionViewCell, indexPath: IndexPath) {
    viewModel?.setCollectionCell(for: cell, indexPath: indexPath)
  }
  @objc func setSelectedSection(sender: UISegmentedControl) {
      viewModel?.setSelectedSection(index: sender.selectedSegmentIndex)
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
  
}

class LibraryViewController: UIViewController {
  var viewModel: ViewModel?
  var collectionView: UICollectionView!

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
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell()}
    setCollectionViewCell(for: cell, indexPath: indexPath)
    return cell
  }
}
