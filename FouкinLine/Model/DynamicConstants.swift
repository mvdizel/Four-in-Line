//
//  DynamicConstants.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 10/18/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import DynamicBinder

/// An enum for defining dynamically changing constants.
enum DynamicConstants {
  static let chipSize = DynamicBinder<CGFloat>(0)
  static let numberOfRows = DynamicBinder<Int>(6)
  static let numberOfColumns = DynamicBinder<Int>(7)
}
