//
//  MatchViewModel.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 27/08/2017.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

/// Protocol which defines match view model.
protocol MatchViewModelProtocol: class {
  
  // MARK: - Instance Attributes
  var chipAdded: DynamicBinderInterface<Chip?> { get }
  var tempChip: DynamicBinderInterface<Chip?> { get }
  var gameStarted: DynamicBinderInterface<Void> { get }
  
  
  // MARK: - Instance Methods
  func addChip(at column: Int)
  func updateTempChip(column: Int?)
  func newGame()
}


/// Class which implements `MatchViewModelProtocol`
final class MatchViewModel: MatchViewModelProtocol {
  
  // MARK: - Public Instance Attributes
  var chipAdded: DynamicBinderInterface<Chip?> { return chipAddedBinder.interface }
  var tempChip: DynamicBinderInterface<Chip?> { return tempChipBinder.interface }
  var gameStarted: DynamicBinderInterface<Void> { return gameStartedBinder.interface }
  
  
  // MARK: - Private Instance Attributes
  private let chipAddedBinder = DynamicBinder<Chip?>(nil)
  private let tempChipBinder = DynamicBinder<Chip?>(nil)
  private let gameStartedBinder = DynamicBinder<Void>()
  
  
  // MARK: - Public Instance Methods
  func addChip(at column: Int) {
    
  }
  
  func updateTempChip(column: Int?) {
    
  }
  
  func newGame() {
    
  }
}
