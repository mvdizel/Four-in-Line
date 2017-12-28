//
//  CGPoint+Extension.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import CoreGraphics

// MARK: - Public Instance Attributes
extension CGPoint {
  
  /// Converts CGPoint into ChipPosition.
  var chipPosition: ChipPosition {
    let column = Int(Swift.max(x, 0))
    let row = Int(Swift.max(y, 0))
    let position = ChipPosition(column: column, row: row)
    return position
  }
}
