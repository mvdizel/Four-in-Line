//
//  GameBoard.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 11/29/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

/// A class defining and managing game board area.
final class GameBoard {
  
  // MARK: - Public Instance Attributes
  private(set) var cells: [[Player?]] = []
  private(set) var columns: Int = 0
  private(set) var rows: Int = 0
  
  
  // MARK: - Initializers
  init() {
    cleanCells()
  }
}


// MARK: - Public Instance Methods
extension GameBoard {
  
  /// Cleans cells.
  func cleanCells() {
    rows = DynamicConstants.numberOfRows.value
    columns = DynamicConstants.numberOfColumns.value
    cells = Array(repeating: Array(repeating: nil, count: rows), count: columns)
  }
  
  /// Returns Player at selected position.
  ///
  /// - Parameter position: Selected `ChipPosition`.
  /// - Returns: A `Player?` at selected position.
  func player(at position: ChipPosition) -> Player? {
    return cells[safe: position.column]?[safe: position.row] as? Player
  }
  
  /// Sets Player at the selected position.
  ///
  /// - Parameters:
  ///   - player: A `Player?` to be set.
  ///   - position: Selected `ChipPosition`.
  func set(_ player: Player?, at position: ChipPosition) {
    guard cells.count > position.column,
          cells[position.column].count > position.row else {
      return
    }
    cells[position.column][position.row] = player
  }
}
