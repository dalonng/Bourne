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
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let variable = Variable(declaration), variable.name.isEmpty == false else {
      fatalError("Invalid usage of @JSONProperty")
    }
    guard let attribute = variable.attributes.first(where: { $0.name == "JSONProperty" }) else {
      fatalError("Invalid usage of @JSONProperty")
    }

    let identifier = variable.name
    let defaultExpr = if let defaultValueExpr = attribute.argument(labeled: "defaultValue") {
      "static let \(identifier) = \(defaultValueExpr)"
    } else {
      ""
    }

    let nameExpr = if let nameExpr = attribute.argument(labeled: "name") {
      "static let \(identifier)Name: String = \(nameExpr)"
    } else {
      ""
    }

    let peerProperty: DeclSyntax = """
    \(raw: defaultExpr)
    \(raw: nameExpr)
    """

    return [peerProperty]
  }
}
