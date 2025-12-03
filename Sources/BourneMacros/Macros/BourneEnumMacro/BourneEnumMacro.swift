//
//  BourneEnumMacro.swift
//  Bourne
//
//  Created by d on 2025/11/19.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BourneEnumMacro: MemberMacro, ExtensionMacro {
  public static func expansion(
    of _: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in _: some MacroExpansionContext,
  ) throws -> [DeclSyntax] {
    let declGroup = DeclGroup(declaration)

    #if DEBUG
    print("Expanding @Bourne(member) for declaration: \(declaration)")
    print("Missing conformances (member side): \(protocols)")
    #endif

    guard case .enum(let decl) = declGroup else {
      throw MacroError("@BounrneEnum can only be applied to enums")
    }

    return try EnumMemberGenerator(enumDecl: decl).generate()
  }

  // MARK: - ExtensionMacro

  public static func expansion(
    of _: AttributeSyntax,
    attachedTo _: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in _: some MacroExpansionContext,
  ) throws -> [ExtensionDeclSyntax] {
    guard !protocols.isEmpty else {
      return []
    }

    #if DEBUG
    print("Expanding @Bourne(extension) for type: \(type)")
    print("Protocols to add on extension: \(protocols)")
    #endif

    let protoList =
      protocols
      .map(\.trimmed.description)
      .joined(separator: ", ")

    let ext = try ExtensionDeclSyntax(
      "extension \(type.trimmed): \(raw: protoList) {}",
    )

    return [ext]
  }
}
