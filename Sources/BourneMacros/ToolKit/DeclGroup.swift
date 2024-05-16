//
//  DeclGroup.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

struct DeclGroup<WrappedSyntax: DeclGroupSyntax>: DeclGroupProtocol {
  var _syntax: WrappedSyntax
  
  init(_ syntax: WrappedSyntax) {
    _syntax = syntax
  }
  
  var identifier: String {
    if let s = asStruct {
      s.identifier
    } else if let e = asEnum {
      e.identifier
    } else {
      fatalError("Unsupported decl group type '\(type(of: _syntax))'")
    }
  }
  
  var asStruct: Struct? {
    Struct(_syntax)
  }
  
  var asEnum: Enum? {
    Enum(_syntax)
  }
}
