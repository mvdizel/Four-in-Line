//
//  GameAI.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

/// A singleton, defining Artificial Intelligence of game.
final class GameAI {
  
  // MARK: - Singleton
  static let shared = GameAI()
  
  
  // MARK: - Initializers
  private init() {}
}

// MARK: Public Instance Methods
extension GameAI {
  
  /// Searches and makes the best move on the gameboard.
  ///
  /// - Parameters:
  ///   - gameBoard: A `GameBoard` with current game state.
  ///   - completion: A handler, which fires, when AI found the best move.
  func bestMove(on gameBoard: GameBoard, completion: @escaping (ChipPosition?) -> Void) {
    let testPosition = firstAvailableMove(on: gameBoard)
    completion(testPosition)
  }
}


// MARK: Private Instance Methods
private extension GameAI {
  
  /// Searches for the first available move on the gameboard.
  ///
  /// - Parameter gameBoard: A `GameBoard` with current game state
  /// - Returns: A `ChipPosition?` representing first available position.
  func firstAvailableMove(on gameBoard: GameBoard) -> ChipPosition? {
    let positions: [ChipPosition] = gameBoard.cells.enumerated().flatMap {
      guard let row = $1.index(where: { $0 == nil}) else {
        return nil
      }
      return ChipPosition(column: $0, row: row, player: .phone)
    }
    return positions.first
  }
}
