//
//  MatchManager.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 3/29/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import DynamicBinder

/// A singleton class for managing game match.
final class MatchManager {
  
  // MARK: - Singleton
  static let shared = MatchManager()
  
  
  // MARK: - Public Instance Attributes
//  private(set) var currentPlayer: Player = .human
  
  
  // MARK: - Private Instance Attributes
  private let gameBoard = GameBoard()
  
  
  // MARK: - Initializers
  private init() {}
}


// MARK: Public Instance Methods
extension MatchManager {

  func newMatch(player: Player) {
    gameBoard.cleanCells()
//    currentPlayer = player
  }

  /// Returns next available cell position for selected column.
  ///
  /// - Parameter columnIndex: An `Int` representing selected column index.
  /// - Returns: A `ChipPosition?` representing available position;
  ///            nil if no available rows for the selected column.
  func availablePosition(at column: Int) -> ChipPosition? {
    guard let rows = gameBoard.cells[safe: column],
          let firstEmpty = rows.index(where: { $0 == nil }) else {
      return nil
    }
    return ChipPosition(column: column, row: firstEmpty, player: .human)
  }

  /// Makes move in selected column index, if possible.
  ///
  /// - Parameters:
  ///   - column: An `Int` representing selected column index.
  ///   - completion: A handler, which fires, when AI made next move.
  func makeMove(at column: Int, completion: @escaping (ChipPosition?) -> Void) {
    guard let position = availablePosition(at: column) else {
      completion(nil)
      return
    }
    gameBoard.set(.human, at: position)
    GameAI.shared.bestMove(on: gameBoard) { [weak self] position in
      guard let position = position else {
        completion(nil)
        return
      }
      self?.gameBoard.set(.phone, at: position)
      completion(position)
    }
  }

  /// Returns player type for selected ChipPosition.
  ///
  /// - Parameter position: A `ChipPosition`, representing selected column and row.
  /// - Returns: A `Player?` for selected IndexPath.
  func player(at position: ChipPosition) -> Player? {
    return gameBoard.player(at: position)
  }
}
