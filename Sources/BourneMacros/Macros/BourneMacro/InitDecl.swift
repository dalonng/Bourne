//
//  InitDecl.swift
//  Bourne
//
//  Created by d on 2025/01/29.
//

import Foundation
import SwiftSyntax

final class InitDecl {
  let structDecl: Struct

  init(structDecl: Struct) {
    self.structDecl = structDecl
  }

  var functionSignatureSyntax: String {
    if let accessLevel = structDecl.accessLevel?.name {
      "\(accessLevel) init("
    } else {
      "init("
    }
  }

  var functionSignatureSyntaxEnd: String {
    "}"
  }

  func functionBodySyntax() -> [String] {
    [parameterSyntaxs] + [") {"] + paramtersAssignSyntaxs
  }

  var parameterSyntaxs: String {
    String.tab
      + structDecl.storedVariables.map { variable in
        "\(variable.name): \(variable.type)"
      }.joined(separator: ", ")
  }

  var paramtersAssignSyntaxs: [String] {
    structDecl.storedVariables.map { variable in
      "  self.\(variable.name) = \(variable.name)"
    }
  }

  func generate() -> DeclSyntax {
    let result = ([functionSignatureSyntax] + functionBodySyntax() + [functionSignatureSyntaxEnd]).joined(separator: "\n")
    return DeclSyntax("\(raw: result)")
  }
}

extension String {
  static let newline = "\n"
  static let tab = "  "
  static let debug = "bugggggg"
}
