//
//  SyntaxProtocol.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

//  什么是 Trivia？
//  Trivia 包含在源代码中但不直接影响代码逻辑的内容，包括：
//
//  空白（Whitespace）：如空格和制表符。
//  注释（Comments）：如单行注释 // 和多行注释 /* ... */。
//  换行符（Newlines）：包括单个换行符和多个连续的换行符。
//  其他：如拼接线 \ 和其他语法糖。
//  leadingTrivia 和 trailingTrivia
//  leadingTrivia：指在语法节点之前的 Trivia 信息。例如，在变量声明之前的空白和注释。
//  trailingTrivia：指在语法节点之后的 Trivia 信息。例如，在变量声明之后的换行符和注释。

extension SyntaxProtocol {
  public func withoutTrival() -> Self {
    var syntax = self
    syntax.leadingTrivia = []
    syntax.trailingTrivia = []
    return syntax
  }
}

extension SyntaxProtocol {
  public func withLeadingNewline() -> Self {
    with(\.leadingTrivia, leadingTrivia + [.newlines(1)])
  }

  public func indented(_ indentation: Indentation = .space(2)) -> Self {
    switch indentation {
    case .space(let space):
      with(\.leadingTrivia, leadingTrivia + [.spaces(space)])
    case .tab:
      with(\.leadingTrivia, leadingTrivia + [.tabs(1)])
    }
  }
}

public enum Indentation {
  case space(Int)
  case tab
}
