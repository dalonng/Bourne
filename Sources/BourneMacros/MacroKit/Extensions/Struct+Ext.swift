//
//  Struct+Ext.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import MacroToolkit
import SwiftSyntax

extension Struct {
  var codableVariables: [Variable] {
    variables.filter(\.isNoInitializer)
  }
}
