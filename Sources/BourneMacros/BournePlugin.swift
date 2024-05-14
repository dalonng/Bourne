//
//  BournePlugin.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct BournePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StringifyMacro.self,
    AutoCodableMacro.self,
  ]
}
