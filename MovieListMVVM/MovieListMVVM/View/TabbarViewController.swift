//
//  TabbarViewController.swift
//  MovieListMVVM
//
//  Created by OS on 10.10.2022.
//

import Foundation
import UIKit

class TabbarViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
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
    navController.navigationBar.prefersLargeTitles = true
    rootViewController.navigationItem.title = title
    return navController
  }

  func setupVCs() {
    viewControllers = [
      createNavController(for: ViewController(), title: NSLocalizedString("Movies", comment: ""), image: UIImage(systemName: "film")!),
      createNavController(for: ViewController(), title: NSLocalizedString("Series", comment: ""), image: UIImage(systemName: "tv")!)
    ]
  }
}
