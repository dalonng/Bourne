//
//  DeclGroupProtocol.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import MacroToolkit
import SwiftSyntax

extension DeclGroupProtocol {
  var variables: [Variable] {
    members.compactMap(\.asVariable)
  }
}
