//
//  Attribute.swift
//
//
//  Created by 大桥 on 2024/6/27.
//

import SwiftSyntax

public struct Attribute {
  public var _syntax: AttributeSyntax

  init(_ _syntax: AttributeSyntax) {
    self._syntax = _syntax
  }

  public var _argumentListSyntax: LabeledExprListSyntax? {
    if case let .argumentList(arguments) = _syntax.arguments {
      arguments
    } else {
      nil
    }
  }

  /// Gets the argument with the given label.
  public func argument(labeled label: String) -> String? {
    _argumentListSyntax?.first { $0.label?.text == label }?.expression.description
  }

  public var arguments: [(label: String, value: String)] {
    guard let argumentList = _argumentListSyntax else {
      return []
    }
    var ret = [(label: String, value: String)]()
    for element in argumentList {
      guard let label = element.label?.text,
            let value = element.expression.as(StringLiteralExprSyntax.self)?.segments.first
      else {
        continue
      }
      ret.append((label: label, value: value.description))
    }
    return ret
  }

  /// The attribute's name.
  public var name: String {
    _syntax.attributeName.as(IdentifierTypeSyntax.self)?.name.text ?? ""
  }
}
