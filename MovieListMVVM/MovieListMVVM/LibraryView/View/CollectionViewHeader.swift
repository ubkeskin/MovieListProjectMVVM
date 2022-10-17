//
//  CollectionViewHeader.swift
//  MovieListMVVM
//
//  Created by OS on 17.10.2022.
//

import Foundation
import UIKit

class CollectionViewHeaderView: UICollectionReusableView {
  static let reuseIdentity = String(describing: CollectionViewHeaderView.self)
  
  var genre: Genre = .movie(section: .popular)
  var section: Section = .popular
  lazy var segmentControl: UISegmentedControl = {
    var segmentControl = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
    switch genre {
      case .tv(section: let section):
        segmentControl.insertSegment(withTitle: "popular", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "top", at: 1, animated: false)
        segmentControl.selectedSegmentIndex = 0
      case .movie(section:let section):
        segmentControl.insertSegment(withTitle: "popular", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "top", at: 1, animated: false)
        segmentControl.insertSegment(withTitle: "nowplaying", at: 2, animated: false)
        segmentControl.selectedSegmentIndex = 0
    }
    return segmentControl
  }()
  
  
    
  required init?(coder: NSCoder) {
    
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
}

extension CollectionViewHeaderView {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.addSubview(segmentControl)
    NSLayoutConstraint.activate([
      segmentControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30)
])
  }
}
