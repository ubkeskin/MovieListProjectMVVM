//
//  Result.swift
//  MovieListMVVM
//
//  Created by OS on 12.10.2022.
//

import Foundation

enum Result<T> {
  case success(T)
  case failure(Error)
}
