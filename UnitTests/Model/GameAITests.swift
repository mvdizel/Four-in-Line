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
  func testBestMoveWhenLose() {
    // MARK: Testing loosing position.
    DynamicConstants.GameAI.maxDepth.value = 9
    DynamicConstants.GameBoard.numberOfColumns.value = 4
    DynamicConstants.GameBoard.numberOfRows.value = 4
    let gameBoard = GameBoard()
    gameBoard.set(.phone, at: ChipPosition(column: 2, row: 0))
    gameBoard.set(.phone, at: ChipPosition(column: 2, row: 1))
    gameBoard.set(.human, at: ChipPosition(column: 1, row: 0))
    gameBoard.set(.human, at: ChipPosition(column: 1, row: 1))
    gameBoard.set(.human, at: ChipPosition(column: 1, row: 2))
    let testExpectation = expectation(description: "Game AI Test.")
    GameAI.shared.bestMove(on: gameBoard) { position in
      XCTAssertEqual(position?.column, 1)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testBestMoveWhenNeutral() {
    // MARK: testing neutral position.
    DynamicConstants.GameAI.maxDepth.value = 2
    DynamicConstants.GameBoard.numberOfColumns.value = 5
    DynamicConstants.GameBoard.numberOfRows.value = 3
    let gameBoard = GameBoard()
    let testExpectation = expectation(description: "Game AI Test.")
    GameAI.shared.bestMove(on: gameBoard) { position in
      XCTAssertEqual(position?.column, 2)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 10.0, handler: nil)
  }
  
  func testBestMoveWhenFork() {
    // MARK: testing neutral position.
    DynamicConstants.GameAI.maxDepth.value = 6
    DynamicConstants.GameBoard.numberOfColumns.value = 5
    DynamicConstants.GameBoard.numberOfRows.value = 3
    let gameBoard = GameBoard()
    gameBoard.set(.phone, at: ChipPosition(column: 2, row: 0))
    gameBoard.set(.human, at: ChipPosition(column: 1, row: 0))
    gameBoard.set(.human, at: ChipPosition(column: 2, row: 0))
    let testExpectation = expectation(description: "Game AI Test.")
    GameAI.shared.bestMove(on: gameBoard) { position in
      XCTAssertEqual(position?.column, 3)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 10.0, handler: nil)
  }
}
