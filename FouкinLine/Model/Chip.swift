//
//  Chip.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 12/27/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

/// A struct representing game Chip flow.
struct Chip {
  
  // MARK: - Public Struct Attributes
  let player: Player
  let position: ChipPosition
  var image: UIImage {
    return player.image()
  }
  
  
  // MARK: - Initializers
  init(for player: Player, at position: ChipPosition) {
    self.player = player
    self.position = position
  }
}
