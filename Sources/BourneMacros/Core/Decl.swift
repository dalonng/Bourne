//
//  Decl.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

struct Decl {
  var _syntex: DeclSyntax

  init(_ syntex: any DeclSyntaxProtocol) {
    _syntex = DeclSyntax(syntex)
  }

  var asEnum: Enum? {
    _syntex.as(EnumDeclSyntax.self).map(Enum.init)
  }

  var asStruct: Struct? {
    _syntex.as(StructDeclSyntax.self).map(Struct.init)
  }

  var asVariable: Variable? {
    _syntex.as(VariableDeclSyntax.self).map(Variable.init)
  }
}
