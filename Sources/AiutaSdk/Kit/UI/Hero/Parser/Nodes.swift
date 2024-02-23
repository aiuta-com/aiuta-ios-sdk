//
//  Nodes.swift
//  Kaleidoscope
//
//  Created by Matthew Cheok on 15/11/15.
//  Copyright © 2015 Matthew Cheok. All rights reserved.
//

import Foundation

class ExprNode: CustomStringConvertible, Equatable {
  var range: CountableRange<Int> = 0..<0
  let name: String
  var description: String {
    return "ExprNode(name: \"\(name)\")"
  }
  init(name: String) {
    self.name = name
  }
}

func == (lhs: ExprNode, rhs: ExprNode) -> Bool {
  return lhs.description == rhs.description
}

class NumberNode: ExprNode {
  let value: Float
  override var description: String {
    return "NumberNode(value: \(value))"
  }
  init(value: Float) {
    self.value = value
    super.init(name: "\(value)")
  }
}

class VariableNode: ExprNode {
  override var description: String {
    return "VariableNode(name: \"\(name)\")"
  }
}

class BinaryOpNode: ExprNode {
  let lhs: ExprNode
  let rhs: ExprNode
  override var description: String {
    return "BinaryOpNode(name: \"\(name)\", lhs: \(lhs), rhs: \(rhs))"
  }
  init(name: String, lhs: ExprNode, rhs: ExprNode) {
    self.lhs = lhs
    self.rhs = rhs
    super.init(name: "\(name)")
  }
}

class CallNode: ExprNode {
  let arguments: [ExprNode]
  override var description: String {
    return "CallNode(name: \"\(name)\", arguments: \(arguments))"
  }
  init(name: String, arguments: [ExprNode]) {
    self.arguments = arguments
    super.init(name: "\(name)")
  }
}

class PrototypeNode: ExprNode {
  let argumentNames: [String]
  override var description: String {
    return "PrototypeNode(name: \"\(name)\", argumentNames: \(argumentNames))"
  }
  init(name: String, argumentNames: [String]) {
    self.argumentNames = argumentNames
    super.init(name: "\(name)")
  }
}

class FunctionNode: ExprNode {
  let prototype: PrototypeNode
  let body: ExprNode
  override var description: String {
    return "FunctionNode(prototype: \(prototype), body: \(body))"
  }
  init(prototype: PrototypeNode, body: ExprNode) {
    self.prototype = prototype
    self.body = body
    super.init(name: "\(prototype.name)")
  }
}
