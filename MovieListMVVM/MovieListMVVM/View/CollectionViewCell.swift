//
//  CollectionViewCell.swift
//  MovieListMVVM
//
//  Created by OS on 11.10.2022.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: CollectionViewCell.self)
  
  lazy var poster: UIImageView = {
    var imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  lazy var movieName: UILabel = {
    var label = UILabel()
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 15)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
}
extension CollectionViewCell {
  override func layoutSubviews() {
    self.contentView.addSubview(poster)
    self.contentView.addSubview(movieName)
    NSLayoutConstraint.activate([
      poster.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
      poster.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
      poster.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
      poster.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -200),
      movieName.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      movieName.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: 5),
      movieName.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10)
    ])
  }
}
