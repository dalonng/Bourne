//
//  Variable+Ext.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import MacroToolkit
import SwiftSyntax

extension Variable {
  var name: String {
    bindings.first?.identifier ?? ""
  }

  var type: String {
    bindings.first?.type?.description ?? "NoType"
  }

  var isLet: Bool {
    _syntax.bindingSpecifier.tokenKind == .keyword(.let)
  }

  var isVar: Bool {
    _syntax.bindingSpecifier.tokenKind == .keyword(.var)
  }

  var isReadOnly: Bool {
    _syntax.bindings.first?.accessorBlock?.accessors.as(CodeBlockItemListSyntax.self) != nil
  }

  var isNoInitializer: Bool {
    !isReadOnly && _syntax.bindings.first?.initializer == nil
  }
}
