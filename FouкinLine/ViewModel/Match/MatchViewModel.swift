//
//  MatchViewModel.swift
//  FourInLine
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
  let currentPlayer = DynamicBinder<Player>(.human)
  
  
  // MARK: - Private Instance Attributes
  
  
  // MARK: - Public Instance Methods
  func addChip(at column: Int) {
    tempChip.value = nil
    guard let position = MatchManager.shared.availablePosition(at: column) else {
      chipAdded.value = nil
      return
    }
    let chip = Chip(for: .human, at: position)
    chipAdded.value = ChipViewModel(chip: chip, isTemp: false)
    currentPlayer.value = .phone
    MatchManager.shared.makeMove(at: column) { [weak self] chipPosition in
      guard let strongSelf = self else {
        return
      }
      strongSelf.currentPlayer.value = .human
      guard let position = chipPosition else {
        strongSelf.chipAdded.value = nil
        return
      }
      let chip = Chip(for: .phone, at: position)
      strongSelf.chipAdded.value = ChipViewModel(chip: chip, isTemp: false)
    }
  }
  
  func updateTempChip(at column: Int?) {
    guard let column = column,
          let position = MatchManager.shared.availablePosition(at: column) else {
      tempChip.value = nil
      return
    }
    let chip = Chip(for: .human, at: position)
    tempChip.value = ChipViewModel(chip: chip, isTemp: true)
  }
  
  func newGame() {
    currentPlayer.value = .human
    chipAdded.value = nil
    tempChip.value = nil
    gameStarted.fire()
  }
}
