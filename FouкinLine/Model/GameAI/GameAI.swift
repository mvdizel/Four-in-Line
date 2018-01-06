//
//  GameAI.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

private enum WinConditions: Int {
  case horizontal = 0
  case vertical
  case upperDiagonal
  case bottomDiagonal
}

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
  private var numberOfColumns: Int = 0
  private var numberOfRows: Int = 0
  private var winScore: Float = 0.0
  private var maxDepth: Int = 0

  
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
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let strongSelf = self else {
        completion(nil)
        return
      }
      strongSelf.cells = []
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
        strongSelf.cells.append(column)
      }
      strongSelf.madeMoves = strongSelf.cells.map { column in
        return column.filter({ $0 < 2 }).count
      }
      let alpha = -Float.infinity
      let beta = Float.infinity
      var iteration = 0
      var depth = 0
      strongSelf.bestColumn = nil
      _ = strongSelf.minimax(
        for: .phone,
        alpha: alpha,
        beta: beta,
        iteration: &iteration,
        depth: &depth
      )
      guard let bestColumn = strongSelf.bestColumn else {
        completion(nil)
        return
      }
      let position = ChipPosition(
        column: bestColumn,
        row: strongSelf.madeMoves[bestColumn]
      )
      completion(position)
    }
  }
}


// MARK: Private Instance Methods
private extension GameAI {
  
  /// Setups initial parameters.
  func setup() {
    DynamicConstants.GameBoard.numberOfColumns.bindAndFire(with: self) { [weak self] numberOfColumns in
      self?.numberOfColumns = numberOfColumns
      self?.calculateCoefficients()
    }
    DynamicConstants.GameBoard.numberOfRows.bindAndFire(with: self) { [weak self] numberOfRows in
      self?.numberOfRows = numberOfRows
    }
    DynamicConstants.GameAI.maxDepth.bindAndFire(with: self) { [weak self] maxDepth in
      self?.maxDepth = maxDepth
      self?.calculateCoefficients()
    }
    DynamicConstants.GameAI.winScore.bindAndFire(with: self) { [weak self] winScore in
      self?.winScore = winScore
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
    for column in 0..<numberOfColumns {
      let row = madeMoves[column]
      guard row < numberOfRows else {
        continue
      }
      // MARK: Calculating current position score.
      makeFakeMove(player: player.rawValue, column, row)
      var score = positionScore(for: player, column: column, row: row)
      // MARK: Calculating future position score when it make sense
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
      // MARK: Additional quality coefficients.
      score *= score > 0 ? 1.0 - depthCoefficients[depth] : 1.0 + depthCoefficients[depth]
      score *= score > 0 ? 1.0 - positionCoefficients[column] : 1.0 + positionCoefficients[column]
      if depth == 1 {
        let plusSign = score < 0 ? "" : " "
        print("d: \(depth), c: \(column), r: \(row), score: \(plusSign)\(score)")
      }
      cancelFakeMove(column, row)
      // MARK: Best move score updates.
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
    var isFork = false
    var isPreFork = false
    for i in 0..<4 {
      guard let condition = WinConditions(rawValue: i) else {
        continue
      }
      var chipsInALine = 1
      var x = column
      var y = row
      var closed = 0
      var opened = 0
      switch condition {
      case .horizontal:
        x += 1
        while cellType(column: x, row: y) == player.rawValue {
          chipsInALine += 1
          x += 1
        }
        closed += cellType(column: x, row: y) == 2 ? 1 : 0
        closed += closed > 0 && cellType(column: x + 1, row: y) == 2 ? 1 : 0
        x = column - 1
        while cellType(column: x, row: y) == player.rawValue {
          chipsInALine += 1
          x -= 1
        }
        opened += cellType(column: x, row: y) == 2 ? 1 : 0
        opened += opened > 0 && cellType(column: x - 1, row: y) == 2 ? 1 : 0
      case .vertical:
        y -= 1
        while cellType(column: x, row: y) == player.rawValue {
          chipsInALine += 1
          y -= 1
        }
      case .upperDiagonal:
        x += 1
        y -= 1
        while cellType(column: x, row: y) == player.rawValue {
          chipsInALine += 1
          x += 1
          y -= 1
        }
        closed += cellType(column: x, row: y) == 2 ? 1 : 0
        closed += closed > 0 && cellType(column: x + 1, row: y - 1) == 2 ? 1 : 0
        x = column - 1
        y = row + 1
        while cellType(column: x, row: y) == player.rawValue {
          chipsInALine += 1
          x -= 1
          y += 1
        }
        opened += cellType(column: x, row: y) == 2 ? 1 : 0
        opened += opened > 0 && cellType(column: x - 1, row: y + 1) == 2 ? 1 : 0
      case .bottomDiagonal:
        x += 1
        y += 1
        while cellType(column: x, row: y) == player.rawValue {
          chipsInALine += 1
          x += 1
          y += 1
        }
        closed += cellType(column: x, row: y) == 2 ? 1 : 0
        closed += closed > 0 && cellType(column: x + 1, row: y + 1) == 2 ? 1 : 0
        x = column - 1
        y = row - 1
        while cellType(column: x, row: y) == player.rawValue {
          chipsInALine += 1
          x -= 1
          y -= 1
        }
        opened += cellType(column: x, row: y) == 2 ? 1 : 0
        opened += opened > 0 && cellType(column: x - 1, row: y - 1) == 2 ? 1 : 0
      }
      guard chipsInALine < 4 else {
        return winScore
      }
      if chipsInALine == 3, opened + closed > 0 {
        isFork = true
      } else if chipsInALine == 2, opened + closed > 2 {
        isPreFork = true
      }
    }
    if isFork {
      return winScore * 0.9
    } else if isPreFork {
      return winScore * 0.8
    } else {
      return winScore * 0.1
    }
  }
  
  func cellType(column: Int, row: Int) -> Int {
    guard cells.count > column, column >= 0,
          cells[column].count > row, row >= 0 else {
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
