//
//  Struct+Ext.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import SwiftSyntax

extension Struct {
  var variables: [Variable] {
    members.compactMap(\.asVariable)
  }

  var storedVariables: [Variable] {
    variables.filter { variable in
      for binding in variable.bindings {
        if !binding.accessors.isEmpty {
          return false
        }

        if variable._syntax.modifiers.contains(where: { mod in
          mod.name.tokenKind == .keyword(.static) || mod.name.tokenKind == .keyword(.class)
        }) {
          return false
        }
      }

      return true
    }
  }
}
