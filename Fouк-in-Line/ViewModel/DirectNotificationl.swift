//
//  DirectNotification.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 27/08/2017.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import CoreGraphics
import DynamicBinder

/// Class which implements binders to directly fire handlers.
final class DirectNotification {
  
  // MARK: - Singleton
  static var shared = DirectNotification()
  
  
  // MARK: - Public Instance Attributes
  let chipSizeBinder = DynamicBinder<CGSize>(.zero)
  
  
  // MARK: - Initializers
  private init() {}
}
