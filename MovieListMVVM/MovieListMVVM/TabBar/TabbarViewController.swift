//
//  TabbarViewController.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//
import UIKit

class TabbarViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray
    UITabBar.appearance().barTintColor = .systemBackground
    tabBar.tintColor = .label
    setupVCs()
  }

  fileprivate func createNavController(for rootViewController: UIViewController,
                                       title: String,
                                       image: UIImage) -> UIViewController
  {
    let navController = UINavigationController(rootViewController: rootViewController)
    navController.tabBarItem.title = title
    navController.tabBarItem.image = image
    rootViewController.navigationItem.title = title
    return navController
  }

  func setupVCs() {
    viewControllers = [
      createNavController(for: LibraryViewController(), title: NSLocalizedString("Movies", comment: ""), image: UIImage(systemName: "film")!),
      createNavController(for: LibraryViewController(), title: NSLocalizedString("Series", comment: ""), image: UIImage(systemName: "tv")!)
    ]
  }
}
