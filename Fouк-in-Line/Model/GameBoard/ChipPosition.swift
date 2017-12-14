//
//  ChipPosition.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import CoreGraphics

/// A struct representing chip position on gemeboard.
struct ChipPosition {

  // MARK: - Public Struct Attributes
  var column: Int
  var row: Int
  var player: Player?

  /// Invert row position, because of in the UIView zero position
  /// starts from the top left corner.
  var rowInView: Int {
    return DynamicConstants.numberOfRows.value - row - 1
  }

  /// Converts ChipPosition into IndexPath.
  var indexPath: IndexPath {
    return IndexPath(row: row, section: column)
  }

  /// Converts ChipPosition into CGPoint.
  var cgPoint: CGPoint {
    return CGPoint(x: column, y: row)
  }

  /// Returns chip position in view, depends on chip and board size.
  var frame: CGRect {
    let chipSize = DynamicConstants.chipSize.value
    return CGRect(
      x: CGFloat(column) * chipSize,
      y: CGFloat(rowInView) * chipSize,
      width: chipSize,
      height: chipSize
    )
  }
}
