//
//  Enum.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

struct Enum: DeclGroupProtocol {
  var _syntax: EnumDeclSyntax

  var identifier: String {
    _syntax.name.withoutTrival().text
  }

  init(_ syntax: EnumDeclSyntax) {
    self._syntax = syntax
  }
}
