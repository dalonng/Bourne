//
//  SyntaxProtocol.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

extension SyntaxProtocol {
  public func withoutTrival() -> Self {
    var syntax = self
    syntax.leadingTrivia = []
    syntax.trailingTrivia = []
    return syntax
  }
}
