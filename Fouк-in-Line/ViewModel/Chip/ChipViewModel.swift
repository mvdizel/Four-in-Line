//
//  ChipViewModel.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 10/18/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit
import DynamicBinder

class ChipViewModel {
  
  // MARK: - Public Instance Attributes
  var isTemp: DynamicBinderInterface<Bool> { return isTempBinder.interface }
  var chipSize: DynamicBinderInterface<CGFloat> { return DynamicConstants.chipSize.interface }
  let chip: Chip
  
  
  // MARK: - Private Instance Attributes
  private let isTempBinder = DynamicBinder<Bool>(false)
  
  
  // MARK: - Initializers
  init(_ chip: Chip) {
    self.chip = chip
  }
  
  
  // MARK: - Public Instance Methods
}
