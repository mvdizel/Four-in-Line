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
  var chipSize: DynamicBinderInterface<CGFloat> {
    return DynamicConstants.chipSize.interface
  }
  let position: ChipPosition
  
  
  // MARK: - Initializers
  init(positon: ChipPosition, isTemp: Bool) {
    self.position = positon
    self.isTemp = DynamicBinder(isTemp)
  }
}
