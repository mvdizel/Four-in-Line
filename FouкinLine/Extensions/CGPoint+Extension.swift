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
    let position = ChipPosition(
      column: Int(Swift.max(x, 0)),
      row: Int(Swift.max(y, 0)),
      player: nil
    )
    return position
  }
}
