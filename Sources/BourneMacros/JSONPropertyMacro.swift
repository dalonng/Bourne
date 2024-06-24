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
    guard let argumentList = attribute.arguments?.as(LabeledExprListSyntax.self) else {
      fatalError("Invalid usage of @JSONProperty")
    }

    guard let variableDecl = declaration.as(VariableDeclSyntax.self),
          let identifier = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
    else {
      fatalError("Invalid usage of @JSONProperty")
    }

    let defaultExpr = if let defaultValueExpr = argumentList.first(where: { $0.label?.text == "defaultValue" })?.expression {
      "static let \(identifier)DefaultValue = \(defaultValueExpr)"
    } else {
      ""
    }

    let nameExpr = if let nameExpr = argumentList.first(where: { $0.label?.text == "name" })?.expression {
      "static let \(identifier)Nmae: String = \(nameExpr)"
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
