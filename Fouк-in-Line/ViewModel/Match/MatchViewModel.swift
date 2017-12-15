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
  let chipAdded = DynamicBinder<ChipViewModel?>(nil)
  let tempChip = DynamicBinder<ChipViewModel?>(nil)
  let gameStarted = DynamicBinder<Void>(())
  
  
  // MARK: - Private Instance Attributes
  
  
  // MARK: - Public Instance Methods
  func addChip(at column: Int) {
    tempChip.value = nil
    guard let position = MatchManager.shared.availablePosition(at: column) else {
      chipAdded.value = nil
      return
    }
    chipAdded.value = ChipViewModel(positon: position, isTemp: false)
  }
  
  func updateTempChip(at column: Int?) {
    guard let column = column,
          let position = MatchManager.shared.availablePosition(at: column) else {
      tempChip.value = nil
      return
    }
    tempChip.value = ChipViewModel(positon: position, isTemp: true)
  }
  
  func newGame() {
    chipAdded.value = nil
    tempChip.value = nil
    gameStarted.fire()
  }
}
