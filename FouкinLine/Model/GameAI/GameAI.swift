//
//  GameAI.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

/// A singleton, defining Artificial Intelligence of game.
final class GameAI {
  
  // MARK: - Singleton
  static let shared = GameAI()
  
  
  // MARK: - Private Instance Attributes
  private var cells: [[Int]] = []
  private var madeMoves: [Int] = []
  private var bestColumn: Int?
  private var positionCoefficients: [Float] = []
  private var depthCoefficients: [Float] = []
  private var winScore: Float {
    return DynamicConstants.GameAI.winScore.value
  }
  private var maxDepth: Int {
    return DynamicConstants.GameAI.maxDepth.value
  }

  
  // MARK: - Initializers
  private init() {
    setup()
  }

  
  // MARK: - De-Initializers
  deinit {
    DynamicConstants.GameBoard.numberOfColumns.unbind(self)
    DynamicConstants.GameAI.maxDepth.unbind(self)
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
    guard let bestColumn = bestColumn else {
      completion(nil)
      return
    }
    let position = ChipPosition(
      column: bestColumn,
      row: madeMoves[bestColumn]
    )
    completion(position)
  }
}


// MARK: Private Instance Methods
private extension GameAI {
  
  func setup() {
    DynamicConstants.GameBoard.numberOfColumns.bindAndFire(with: self) { [weak self] _ in
      self?.calculateCoefficients()
    }
    DynamicConstants.GameAI.maxDepth.bind(with: self) { [weak self] _ in
      self?.calculateCoefficients()
    }
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
      return ChipPosition(column: $0, row: row)
    }
    return positions.first
  }
  
  func minimax(for player: Player,
               alpha: Float,
               beta: Float,
               iteration: inout Int,
               depth: inout Int) -> Float {
    var newAlpha = alpha
    depth += 1
    iteration += 1
    defer {
      depth -= 1
    }
    // @TODO: Check if winner found on current move.
    // @TODO: Update score with current depth.
    // @TODO: Check for forks.
    for column in 0..<DynamicConstants.GameBoard.numberOfColumns.value {
      let row = madeMoves[column]
      guard row < DynamicConstants.GameBoard.numberOfRows.value else {
        continue
      }
      makeFakeMove(player: player.rawValue, column, row)
      var score = positionScore(for: player, column: column, row: row)
//      score *= depthCoefficients[depth]
      if score <= winScore - 1.0, depth < maxDepth {
        let futureScore = minimax(
          for: player.next(),
          alpha: -beta,
          beta: -alpha,
          iteration: &iteration,
          depth: &depth
        )
        if futureScore != Float.infinity {
          score = futureScore
        }
      }
      score *= score > 0 ? 1.0 - depthCoefficients[depth] : 1.0 + depthCoefficients[depth]
      score *= score > 0 ? 1.0 - positionCoefficients[column] : 1.0 + positionCoefficients[column]
      let plusSign = score < 0 ? "" : " "
      print("d: \(depth), c: \(column), r: \(row), cells: \(cells[0][0])\(cells[1][0])\(cells[2][0]), score: \(plusSign)\(score)")
      if depth == 1 {
        print("")
      }
//      score *= positionCoefficients[column]
      cancelFakeMove(column, row)
      if score > newAlpha {
        newAlpha = score
        if depth == 1 {
          bestColumn = column
        }
      }
      guard newAlpha <= beta else {
        break
      }
    }
    return -newAlpha
  }
  
  func makeFakeMove(player: Int, _ column: Int, _ row: Int) {
    cells[column][row] = player
    cells[column][row + 1] = 2
    madeMoves[column] += 1
  }
  
  func cancelFakeMove(_ column: Int, _ row: Int) {
    cells[column][row] = 2
    cells[column][row + 1] = 3
    madeMoves[column] -= 1
  }

  func positionScore(for player: Player, column: Int, row: Int) -> Float {
    if
      cells[0][0] == player.rawValue &&
      cells[0][1] == player.rawValue
        &&
      cells[0][2] == player.rawValue
        ||
      cells[1][0] == player.rawValue &&
      cells[1][1] == player.rawValue
        &&
      cells[1][2] == player.rawValue ||
      cells[2][0] == player.rawValue &&
      cells[2][1] == player.rawValue &&
      cells[2][2] == player.rawValue ||
      cells[0][0] == player.rawValue &&
      cells[1][0] == player.rawValue &&
      cells[2][0] == player.rawValue ||
      cells[0][1] == player.rawValue &&
      cells[1][1] == player.rawValue &&
      cells[2][1] == player.rawValue ||
      cells[0][2] == player.rawValue &&
      cells[1][2] == player.rawValue &&
      cells[2][2] == player.rawValue ||
      cells[0][0] == player.rawValue &&
      cells[1][1] == player.rawValue &&
      cells[2][2] == player.rawValue ||
      cells[0][2] == player.rawValue &&
      cells[1][1] == player.rawValue &&
      cells[2][0] == player.rawValue
    {
      return winScore
    }
    return winScore - 1.0
//    // @TODO: Check real score
//    // @TODO: Use coefficients dependent on player or not?
  }
  
  func cellType(column: Int, row: Int) -> Int {
    guard cells.count > column, cells[column].count > row else {
      return 3
    }
    return cells[column][row]
  }
  
  func calculateCoefficients() {
    positionCoefficients.removeAll()
    let center = 0.5 + Float(DynamicConstants.GameBoard.numberOfColumns.value) / 2.0
    for column in 1...DynamicConstants.GameBoard.numberOfColumns.value {
      let coefficient = abs(Float(column) - center) / (center * 1000)
      positionCoefficients.append(coefficient)
    }
    depthCoefficients.removeAll()
    for depth in 0...maxDepth {
      let coefficient = Float(depth) / (Float(maxDepth) * 1000)
      depthCoefficients.append(coefficient)
    }
  }
}
