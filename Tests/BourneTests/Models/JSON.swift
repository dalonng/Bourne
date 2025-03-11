//
//  JSON.swift
//  Bourne
//
//  Created by d on 2025/03/11.
//

import Foundation

extension String {
  var jsonData: Data! {
    data(using: .utf8)
  }

  public func forceDecode<T: Decodable>() throws -> T {
    try JSONDecoder().decode(T.self, from: jsonData)
  }
}

extension Decodable {
  public static func forceDecode<T: Decodable>(data: Data) -> T {
    try! JSONDecoder().decode(T.self, from: data)
  }
}
