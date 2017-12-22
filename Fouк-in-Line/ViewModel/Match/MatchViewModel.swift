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
  let currentPlayer = DynamicBinder<Player>(.human)
  
  
  // MARK: - Private Instance Attributes
  
  
  // MARK: - Public Instance Methods
  func addChip(at column: Int) {
    tempChip.value = nil
    guard let position = MatchManager.shared.availablePosition(at: column) else {
      chipAdded.value = nil
      return
    }
    currentPlayer.value = .phone
    chipAdded.value = ChipViewModel(positon: position, isTemp: false)
    MatchManager.shared.makeMove(at: column) { [weak self] chipPosition in
      self?.currentPlayer.value = .human
      guard let position = chipPosition else {
        self?.chipAdded.value = nil
        return
      }
      self?.chipAdded.value = ChipViewModel(positon: position, isTemp: false)
    }
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
    currentPlayer.value = .human
    chipAdded.value = nil
    tempChip.value = nil
    gameStarted.fire()
  }
}
