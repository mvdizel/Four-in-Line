//
//  GameAITests.swift
//  UnitTests
//
//  Created by Vasilii Muravev on 12/23/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import XCTest
@testable import FourInLine

final class GameAITests: BaseTests {
  
  // MARK: - Functional tests.
  func testBestMove() {
    DynamicConstants.GameAI.maxDepth.value = 100
    DynamicConstants.GameBoard.numberOfColumns.value = 3
    DynamicConstants.GameBoard.numberOfRows.value = 3
    let gameBoard = GameBoard()
    // MARK: Premoves
//    gameBoard.set(.phone, at: ChipPosition(column: 0, row: 0))
//    gameBoard.set(.human, at: ChipPosition(column: 1, row: 0))
//    gameBoard.set(.human, at: ChipPosition(column: 1, row: 1))
    let testExpectation = expectation(description: "Game AI Test.")
    GameAI.shared.bestMove(on: gameBoard) { position in
      XCTAssertNotNil(position)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
}
