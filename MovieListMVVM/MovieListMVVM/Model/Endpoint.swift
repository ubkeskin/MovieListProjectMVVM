//
//  Endpoint.swift
//  MovieListMVVM
//
//  Created by OS on 12.10.2022.
//

import Foundation

protocol Endpoint {
  func provideValues(section: Section, genre: Genre)-> (url: URL, method: String, parameters: [String: Any])
  
  var url: URL { get }
  var method: String { get }
  var parameters: [String:Any] { get }
}
extension Endpoint {
  var url: URL { provideValues(section: Section, genre: Genre)().url }
  var method: String { provideValues(section: Section, genre: Genre)().method }
  var parameters: [String: Any] { provideValues(section: Section, genre: Genre)().parameters }
}
