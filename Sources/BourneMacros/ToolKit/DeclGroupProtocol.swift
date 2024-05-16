//
//  DeclGroupProtocol.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

protocol DeclGroupProtocol {
  associatedtype WrappedSyntax: DeclGroupSyntax

  var _syntax: WrappedSyntax { get }

  var identifier: String { get }

  init(_ syntax: WrappedSyntax)
}

extension DeclGroupProtocol {
  init?(_ syntax: DeclGroupSyntax) {
    guard let syntax = syntax.as(WrappedSyntax.self) else {
      return nil
    }
    self.init(syntax)
  }

  var members: [Decl] {
    _syntax.memberBlock.members.map(\.decl).map(Decl.init)
  }

  var variables: [Variable] {
    members.compactMap(\.asVariable)
  }
}
