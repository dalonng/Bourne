//
//  VariableAnalyzer.swift
//
//
//  Created by 大桥 on 2024/6/21.
//

import Bourne
import BourneMacros
import Foundation
import SwiftParser
import SwiftSyntax

class VariableAnalyzer: SyntaxVisitor {
  override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
    print("------------------------------")
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
      }
      if let type = binding.typeAnnotation?.type {
        print("typeAnnotation: \(type), kind: \(type.kind), type: \(type.self)")
      }
    }

    let property = node
    let propertyName = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text ?? ""
    print("propertyName: \(propertyName)")
    let attributes = property.attributes.compactMap { $0.as(AttributeSyntax.self) }
    for attribute in attributes {
      print("attribute: \(attribute):")
      if let attributeName = attribute.attributeName.as(IdentifierTypeSyntax.self) {
        print("\tattributeName: \(attributeName.name.text)")
      }
      if let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) {
        for element in arguments {
          if let label = element.label?.text, let value = element.expression.as(StringLiteralExprSyntax.self)?.segments.first {
            print("\t\tlabel: \(label), value: \(value)")
          }
        }
      }
    }
    return .skipChildren
  }

  override func visit(_ node: AttributeSyntax) -> SyntaxVisitorContinueKind {
    if let argumentList = node.arguments?.as(LabeledExprListSyntax.self) {
      for element in argumentList {
        if let label = element.label?.text, let value = element.expression.as(StringLiteralExprSyntax.self)?.segments.first {
          print("Label: \(label), Value: \(value)")
        }
      }
    }
    return .skipChildren
  }
}
