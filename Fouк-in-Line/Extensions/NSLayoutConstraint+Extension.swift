//
//  NSLayoutConstraint+Extension.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 5/13/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

// MARK: - Public Instance Methods
extension NSLayoutConstraint {

  /// Returns a copy of current constraint with a different multiplier.
  func copy(multiplier newMultiplier: CGFloat) -> NSLayoutConstraint {
    let newConstraint = NSLayoutConstraint(
      item: firstItem as Any,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: newMultiplier,
      constant: constant
    )
    return newConstraint
  }
}
