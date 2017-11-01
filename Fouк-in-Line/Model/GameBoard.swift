//
//  GameBoard.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 10/31/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

enum FieldStatus {
  case empty(Bool)
  case hold(Player)
  
  func isEmpty() -> Bool {
    switch self {
    case .empty(_):
      return true
    default:
      return false
    }
  }
}

final class GameBoard {
  
  // MARK: - Public Instance Attributes
  private(set) var columns: Int = 0
  private(set) var rows: Int = 0

  
  // MARK: - Private Instance Attributes
  private var board: [[FieldStatus]] = []

  
  // MARK: - Public Instance Methods
  func turnAllowed(at column: Int) -> Bool {
    guard column <= columns else { return false }
    return board[column - 1].last!.isEmpty()
  }
}
