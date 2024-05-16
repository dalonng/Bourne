//
//  Struct.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

public struct Struct: DeclGroupProtocol {
  public var _syntax: StructDeclSyntax

  public var identifier: String {
    _syntax.name.withoutTrival().text
  }

  public init(_ syntax: StructDeclSyntax) {
    _syntax = syntax
  }
}
