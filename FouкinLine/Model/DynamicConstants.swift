//
//  DynamicConstants.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 10/18/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import DynamicBinder

/// An enum for defining dynamically changing constants.
enum DynamicConstants {
  
  // MARK: - Game chip constants.
  enum Chip {
    static let size = DynamicBinder<CGFloat>(0)
  }
  
  
  // MARK: - GameBoard constants.
  enum GameBoard {
    static let numberOfRows = DynamicBinder<Int>(6)
    static let numberOfColumns = DynamicBinder<Int>(7)
  }
  
  
  // MARK: - Game AI constants.
  enum GameAI {
    static let maxDepth = DynamicBinder<Int>(2)
    static let winScore = DynamicBinder<Float>(10.0)
  }
}
