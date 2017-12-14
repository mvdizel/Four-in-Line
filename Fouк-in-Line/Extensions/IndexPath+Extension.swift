//
//  IndexPath+Extension.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

// MARK: - Public Instance Attributes
extension IndexPath {

  /// Converts IndexPath into ChipPosition.
  var chipPosition: ChipPosition {
    let position = ChipPosition(
      column: Swift.max(section, 0),
      row: Swift.max(row, 0),
      player: nil
    )
    return position
  }
}
