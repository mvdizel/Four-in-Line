//
//  FILGameManager.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 3/29/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

enum Player: Int {
    case first = 0
    case second
    
    func nextPlayer() -> Player {
        if self == .first {
            return .second
        }
        return .first
    }
    
    func image() -> UIImage {
        switch self {
        case .first:
            return #imageLiteral(resourceName: "chip-blue")
        case .second:
            return #imageLiteral(resourceName: "chip-red")
        }
    }
}

enum Difficulty {
    case normal
    case hard
}

class FILGameManager: NSObject {
    
    // MARK: - Singleton
    static let shared = FILGameManager()
    
    
    // MARK: - Public Instance Attributes
    var tempMoveCondition: DynamicBinderInterface<(player: Player, position: FILChipPosition)?> {
        return tempMoveConditionBinder.interface
    }
    var moveCondition: DynamicBinderInterface<(player: Player, position: FILChipPosition)?> {
        return moveConditionBinder.interface
    }
    fileprivate(set) var numOfRows: Int = 16
    fileprivate(set) var numOfColumns: Int = 11
    fileprivate(set) var difficulty: Difficulty = .normal
    
    
    // MARK: - Private Instance Attributes
    fileprivate var gameOver: Bool = false
    fileprivate var currentPlayer: Player = .first
    fileprivate let tempMoveConditionBinder: DynamicBinder<(player: Player, position: FILChipPosition)?> = DynamicBinder(nil)
    fileprivate let moveConditionBinder: DynamicBinder<(player: Player, position: FILChipPosition)?> = DynamicBinder(nil)
    fileprivate var gameBoard: FILGameBoard {
        return FILGameBoard.shared
    }
}


// MARK: Public Instance Methods
extension FILGameManager {
    func makeTempMove(for column: Int) {
        tempMoveConditionBinder.value = allowedModeCondition(for: column)
    }
    
    func makeMove(for column: Int) {
        moveConditionBinder.value = allowedModeCondition(for: column)
        guard let moveCondition = moveCondition.value else { return }
        gameBoard.set(.player(moveCondition.player), for: moveCondition.position)
        currentPlayer = currentPlayer.nextPlayer()
    }
}


// MARK: Private Instance Methods
fileprivate extension FILGameManager {
    func allowedModeCondition(for column: Int) -> (player: Player, position: FILChipPosition)? {
        guard let position = gameBoard.allowedPosition(column: column) else {
            return nil
        }
        return (currentPlayer, position)
    }
}
