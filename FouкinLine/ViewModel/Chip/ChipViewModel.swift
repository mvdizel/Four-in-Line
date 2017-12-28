//
//  ChipViewModel.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 10/18/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import DynamicBinder

/// A class for defining and implementing chip logic.
final class ChipViewModel {
  
  // MARK: - Public Instance Attributes
  let isTemp: DynamicBinder<Bool>
  var position: ChipPosition {
    return chip.position
  }
  var image: UIImage {
    return chip.image
  }
  
  
  // MARK: - Private Instance Attributes
  let chip: Chip
  
  
  // MARK: - Initializers
  init(chip: Chip, isTemp: Bool) {
    self.chip = chip
    self.isTemp = DynamicBinder(isTemp)
  }
}
