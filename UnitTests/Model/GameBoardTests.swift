//
//  GameBoardTests.swift
//  UnitTests
//
//  Created by Vasilii Muravev on 12/27/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import XCTest
@testable import FourInLine

final class GameBoardTests: BaseTests {
  
  // MARK: Functional Tests
  func testSetAndGetPlayer() {
    let gameBoard = GameBoard()
    let position = ChipPosition(column: 0, row: 0)
    let testPlayer: Player = .human
    XCTAssertNil(gameBoard.player(at: position))
    gameBoard.set(testPlayer, at: position)
    XCTAssertEqual(gameBoard.player(at: position), testPlayer)
  }
  
  func testCleanCells() {
    let gameBoard = GameBoard()
    let position = ChipPosition(column: 0, row: 0)
    let testPlayer: Player = .human
    XCTAssertNil(gameBoard.player(at: position))
    gameBoard.set(testPlayer, at: position)
    XCTAssertEqual(gameBoard.player(at: position), testPlayer)
    gameBoard.cleanCells()
    XCTAssertNil(gameBoard.player(at: position))
  }
}
