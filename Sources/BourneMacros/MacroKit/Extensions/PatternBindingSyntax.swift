//
//  PatternBindingSyntax.swift
//  Bourne
//
//  Created by d on 2025/11/19.
//

import SwiftSyntax

extension PatternBindingSyntax {
  var isStoredProperty: Bool {
    guard let accessorBlock else {
      return true
    }

    switch accessorBlock.accessors {
    case .getter:
      return false

    case .accessors(let list):
      var hasGetOrSet = false
      var hasObserver = false

      for accessor in list {
        switch accessor.accessorSpecifier.tokenKind {
        case .keyword(.get),
             .keyword(.set):
          hasGetOrSet = true
        case .keyword(.didSet),
             .keyword(.willSet):
          hasObserver = true
        default:
          break
        }
      }

      if hasObserver {
        return true
      }

      return !hasGetOrSet
    }
  }
}
