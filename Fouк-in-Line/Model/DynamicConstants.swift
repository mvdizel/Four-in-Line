//
//  DynamicConstants.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 10/18/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import DynamicBinder

class DynamicConstants {
  
  // MARK: - Public Class Attribites
  static let chipSize = DynamicBinder<CGFloat>(0)
  
  
  // MARK: - Initializers
  @available(*, unavailable) private init() {
    fatalError("unavailable")
  }
}

