//
//  Player.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 11/29/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

/// An enum representing players type.
enum Player: Int {
  case human = 0
  case phone
  
  /// Returns next player in order.
  ///
  /// - Returns: A `Player` next in order after current.
  func next() -> Player {
    return self == .human ? .phone : .human
  }
  
  /// Returns an image, related to the current player.
  ///
  /// - Returns: A `UIImage` related to the current user.
  func image() -> UIImage {
    switch self {
    case .human:
      return #imageLiteral(resourceName: "chip-blue")
    case .phone:
      return #imageLiteral(resourceName: "chip-red")
    }
  }
}
