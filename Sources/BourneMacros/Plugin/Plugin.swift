//
//  Plugin.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct Plugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    BourneMacro.self,
    BourneEnumMacro.self,
    JSONPropertyMacro.self,
  ]
}
