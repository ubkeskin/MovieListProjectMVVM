//
//  Endpoint.swift
//  MovieListMVVM
//
//  Created by OS on 12.10.2022.
//

import Foundation

protocol Endpoint {
  var url: URL {get}
  var method: String {get}
  var parameters: [String: String] {get}
  func provideValues()-> (url: URL, method: String, parameters: [String: String])
}
extension Endpoint {
  var url: URL {provideValues().url}
  var method: String {provideValues().method}
  var parameters: [String: String] {provideValues().parameters}
}
