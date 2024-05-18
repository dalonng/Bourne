//
//  AccessLevelModifier.swift
//
//
//  Created by d on 2024/05/18.
//

import SwiftSyntax

public enum AccessLevelModifier: String, Comparable, CaseIterable {

  case `private`
  case `fileprivate`
  case `internal`
  case `public`
  case `open`

  public static func < (lhs: AccessLevelModifier, rhs: AccessLevelModifier) -> Bool {
    let lhs = Self.allCases.firstIndex(of: lhs)!
    let rhs = Self.allCases.firstIndex(of: rhs)!
    return lhs < rhs
  }

  var isPublic: Bool {
    self == .public
  }
}

public protocol AccessLevelSyntax {
  var modifiers: DeclModifierListSyntax { get }
}

extension AccessLevelSyntax {
  public var accessLevel: AccessLevelModifier {
    modifiers.lazy.compactMap({ AccessLevelModifier(rawValue: $0.name.text) }).first ?? .internal
  }
}

extension DeclGroupSyntax {
  public var declAccessLevel: AccessLevelModifier {
    (self as? AccessLevelSyntax)?.accessLevel ?? .internal
  }
}
