//
//  VariableAnalyzer.swift
//
//
//  Created by 大桥 on 2024/6/21.
//

import SwiftParser
import SwiftSyntax

class VariableAnalyzer: SyntaxVisitor {
  override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
    print("------------------------------")
//    print(node.modifiers)
//    print(node.bindingSpecifier)
//    print(node.bindingSpecifier.kind)
//    print(node.bindingSpecifier.tokenKind)
    let name = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text ?? ""

    let isLet = node.bindingSpecifier.tokenKind == .keyword(.let)
    let isVar = node.bindingSpecifier.tokenKind == .keyword(.var)

    if let accessors = node.bindings.first?.accessorBlock?.accessors.as(AccessorDeclListSyntax.self) {
      print("accessors: \(accessors)")
    }
    if let accessors = node.bindings.first?.accessorBlock?.accessors.as(CodeBlockItemListSyntax.self) {
      print("accessors: \(accessors)")
    }

    print("\(name): isLet \(isLet), isVar \(isVar)")

    for binding in node.bindings {
      if let accessors = binding.accessorBlock?.accessors.as(InitializerClauseSyntax.self) {
        print("accessors: \(accessors)")
      }
      if let identifierPattern = binding.pattern.as(IdentifierPatternSyntax.self) {
        print("IdentifierPattern: \(identifierPattern)")
//        let accessors = binding.accessor?.accessors
//        let isGetOnly = accessors?.allSatisfy { $0.is(GetAccessorSyntax.self) } ?? false
//
//        if let accessors {
//          for accessor in accessors {
//            print("Accessor: \(accessor)")
//          }
//        }
      }
    }
    return .skipChildren
  }
}
