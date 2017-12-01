//
//  MatchViewModel.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 27/08/2017.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import DynamicBinder

final class MatchViewModel {
  
  // MARK: - Public Instance Attributes
  let chipAddedBinder = DynamicBinder<ChipViewModel?>(nil)
  let tempChipBinder = DynamicBinder<ChipViewModel?>(nil)
  let gameStartedBinder = DynamicBinder<Void>(())
  
  
  // MARK: - Public Instance Methods
  func addChip(at column: Int) {
    
  }
  
  func updateTempChip(at column: Int?) {
    
  }
  
  func newGame() {
    
  }
}
