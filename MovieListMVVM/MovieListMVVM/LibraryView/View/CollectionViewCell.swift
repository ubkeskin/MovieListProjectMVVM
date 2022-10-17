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
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 12)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var ratingLabel: UILabel = {
    var label = UILabel()
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 10)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var popularityLabel: UILabel = {
    var label = UILabel()
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 10)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var releaseDateLabel: UILabel = {
    var label = UILabel()
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 10)
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
    contentView.addSubview(poster)
    contentView.addSubview(movieName)
    contentView.addSubview(popularityLabel)
    contentView.addSubview(ratingLabel)
    contentView.addSubview(releaseDateLabel)
    NSLayoutConstraint.activate([
      poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
      poster.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
      poster.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -200),
      movieName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      movieName.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: 5),
      movieName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
      popularityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 30),
      popularityLabel.leftAnchor.constraint(equalTo: movieName.leftAnchor),
      popularityLabel.rightAnchor.constraint(equalTo: movieName.rightAnchor),
      ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 50),
      ratingLabel.leftAnchor.constraint(equalTo: movieName.leftAnchor),
      ratingLabel.rightAnchor.constraint(equalTo: movieName.rightAnchor),
      releaseDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 70),
      releaseDateLabel.leftAnchor.constraint(equalTo: movieName.leftAnchor),
      releaseDateLabel.rightAnchor.constraint(equalTo: movieName.rightAnchor)
    ])
  }
}
