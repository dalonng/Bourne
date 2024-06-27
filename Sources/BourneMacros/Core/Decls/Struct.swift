//
//  Struct.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

public struct Struct: DeclGroupProtocol {

  public var accessLevel: AccessLevelModifier {
    _syntax.modifiers.lazy.compactMap({ AccessLevelModifier(rawValue: $0.name.text) }).first ?? .internal
  }

  var _syntax: StructDeclSyntax

  public var identifier: String {
    _syntax.name.withoutTrival().text
  }

  public init(_ syntax: StructDeclSyntax) {
    _syntax = syntax
  }
}
