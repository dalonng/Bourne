//
//  DeclGroupProtocol.swift
//  Bourne
//
//  Created by d on 2025/11/19.
//

import SwiftSyntax

extension DeclGroupProtocol {
  var storedProperties: [Property] {
    properties.filter(\.isStored)
  }

  var isEnum: Bool {
    self is Enum
  }

  var isStruct: Bool {
    self is Struct
  }

  var isClass: Bool {
    self is Class
  }
}
