//
//  GameAI.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

private let winScore: Float = 10.0
private let maxDepth: Int = 3

/// A singleton, defining Artificial Intelligence of game.
final class GameAI {
  
  // MARK: - Singleton
  static let shared = GameAI()
  
  
  // MARK: - Private Instance Attributes
  var cells: [[Int]] = []
  var madeMoves: [Int] = []
  var bestColumn: Int!
  
  
  // MARK: - Initializers
  private init() {
    setup()
  }
}

// MARK: Public Instance Methods
extension GameAI {
  
  /// Searches and makes the best move on the gameboard.
  ///
  /// - Parameters:
  ///   - gameBoard: A `GameBoard` with current game state.
  ///   - completion: A handler, which fires, when AI found the best move.
  func bestMove(on gameBoard: GameBoard, completion: @escaping (ChipPosition?) -> Void) {
//    let testPosition = firstAvailableMove(on: gameBoard)
//    completion(testPosition)
//    return
    cells = []
    gameBoard.cells.forEach { rows in
      var column: [Int] = []
      rows.forEach({ player in
        if let cellType = player?.rawValue {
          column.append(cellType)
          return
        }
        let cellType = (column.last ?? 0) < 2 ? 2 : 3
        column.append(cellType)
      })
      column.append(3)
      cells.append(column)
    }
    madeMoves = cells.map { column in
      return column.filter({ $0 < 2 }).count
    }
    let alpha = -Float.infinity
    let beta = Float.infinity
    var iteration = 0
    var depth = 0
    bestColumn = nil
    _ = minimax(
      for: .phone,
      alpha: alpha,
      beta: beta,
      iteration: &iteration,
      depth: &depth
    )
    let position = ChipPosition(
      column: bestColumn,
      row: madeMoves[bestColumn],
      player: .phone
    )
    completion(position)
  }
}


// MARK: Private Instance Methods
private extension GameAI {
  
  func setup() {
  }
  
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
  
  func minimax(for player: Player, alpha: Float, beta: Float, iteration: inout Int, depth: inout Int) -> Float {
    var alpha = alpha
    depth += 1
    defer {
      depth -= 1
    }
    // @TODO: Check if winner found on current move.
    // @TODO: Update score with current depth.
    // @TODO: Check for forks.
    iteration += 1
    for column in 0..<DynamicConstants.numberOfColumns.value-1 {
      let row = madeMoves[column]
      guard row < DynamicConstants.numberOfRows.value else {
        continue
      }
      cells[column][row] = player.rawValue
      cells[column][row + 1] = 2
      madeMoves[column] += 1
      var score = positionScore(for: player)
      if score < winScore, depth < maxDepth {
        score = minimax(
          for: player.next(),
          alpha: -beta,
          beta: -alpha,
          iteration: &iteration,
          depth: &depth
        )
      }
      cells[column][row] = 2
      cells[column][row + 1] = 3
      madeMoves[column] -= 1
      if score > alpha {
        alpha = score
        if depth == 1 {
          bestColumn = column
        }
      }
      if alpha >= beta {
        break
      }
    }
    return -alpha
  }
  
  func positionScore(for player: Player) -> Float {
    return 10.0
  }
}
