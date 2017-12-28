//
//  IndexPath+Extension.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

// MARK: - Public Instance Attributes
extension IndexPath {

  /// Converts IndexPath into ChipPosition.
  var chipPosition: ChipPosition {
    let column = Swift.max(self.section, 0)
    let row = Swift.max(self.row, 0)
    let position = ChipPosition(column: column, row: row)
    return position
  }
}
