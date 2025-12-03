//
//  JSONPropertyMacro.swift
//
//
//  Created by 大桥 on 2024/6/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct JSONPropertyMacro: PeerMacro {
  public static func expansion(
    of attribute: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext,
  ) throws -> [DeclSyntax] {
    guard let variable = Variable(declaration), variable.name.isEmpty == false else {
      fatalError("Invalid usage of @JSONProperty")
    }

    return [
      """
      \(raw: variable.defaultExpr)
      \(raw: variable.nameExpr)

      """
    ]
  }
}
