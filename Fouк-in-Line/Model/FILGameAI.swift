//
//  FILGameAI.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 3/29/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

fileprivate let WinLineSize = 4
fileprivate let MaxDepthNormal = 4
fileprivate let MaxDepthHard = 8

class FILGameAI: NSObject {

    // MARK: - Singleton
    static let shared = FILGameAI()
    
    
    // MARK: - Private Instanse Properties
    fileprivate var _gameboard: [[UInt]] = Array(repeating: [], count: 4)
    fileprivate var _maxDepth: Int = 0
    fileprivate var _depth: Int = 0
    fileprivate var _numOfColumns: Int = 0
    fileprivate var _numOfLines: Int = 0
    fileprivate var _firstPlayerWinLine: UInt = 0o0
    fileprivate var _secondPlayerWinLine: UInt = 0o0
    fileprivate var _firstPlayerForkLine: UInt = 0o0
    fileprivate var _secondPlayerForkLine: UInt = 0o0
    fileprivate var _movesStack: UInt = 0x0
    
    
    // MARK: - Initializers
    override init() {
        super.init()
        clearBoard()
    }
}


// MARK: - Public Instance Methods
extension FILGameAI {
    func clearBoard() {
        initializeBoard()
    }
    
    func nextMove() -> CGPoint {
        let moves = _movesStack
        let center = Float(_numOfColumns) / 2.0 + 0.5
        let beta = Float.infinity
        var alpha = -Float.infinity
        var bestMove = CGPoint.zero
        _depth = 0
        for x in 1..._numOfColumns {
            let y = Int((moves >> UInt(4 * (x - 1))) & 0xf) + 1;
            if y > _numOfLines {
                continue
            }
            let move = CGPoint(x: x, y: y)
            let score = fakeMoveForPlayer(.second, atPoint: move)
            if score == .win {
                cancelMoveForPlayer(.second, atPoint: move)
                return move
            }
            var scoreLvl = positionValuationForPlayer(.first, alpha: -beta, beta: -alpha, isFork: false)
            cancelMoveForPlayer(.second, atPoint: move)
            let centerK = 1.0 - (scoreLvl < 0.0 ? -1.0 : 1.0) * fabsf(Float(move.x) - center) / center / 10000.0
            let randomK = 1.0 - (scoreLvl < 0.0 ? -1.0 : 1.0) * Float(arc4random_uniform(100)) / 1000000.0
            scoreLvl *= centerK * randomK
            if scoreLvl > alpha {
                alpha = scoreLvl
                bestMove = move
            } else if bestMove.equalTo(CGPoint.zero) {
                bestMove = move
            }
        }
        return bestMove
    }
}


// MARK: - Private Instance Methods
fileprivate extension FILGameAI {
    
    enum CellStatus: UInt {
        case unallowed      = 0b000 // 0o0
        case allowed        = 0b001 // 0o1
        case firstPlayer    = 0b010 // 0o2
        case secondPlayer   = 0b100 // 0o4
        
        static let step: UInt = 3
    }
    
    enum Score: Float {
        case none = 0.0
        case fork = 9.0
        case win = 10.0
//        func level(score: Score) -> Float {
//            
//        }
    }
    
    func positionValuationForPlayer(_ player: Player, alpha: Float, beta: Float, isFork: Bool) -> Float {
        _depth += 1
        defer {
            _depth -= 1
        }
        var moves = _movesStack
        var forkMoves: UInt = 0
        var willBeFork: Bool = false
        var alpha = alpha
        
        for x in 1..._numOfColumns {
            let y = Int((moves >> UInt(4 * (x - 1))) & 0xf) + 1;
            if y > _numOfLines {
                continue
            }
            let score = fakeMoveForPlayer(player, atPoint: CGPoint(x: x, y: y))
            cancelMoveForPlayer(player, atPoint: CGPoint(x: x, y: y))
            switch score {
            case .win:
                return -scoreLevel(score)
            case .fork:
                forkMoves |= (0xf << 4 * UInt(x - 1)) & moves
                willBeFork = true
            default:
                forkMoves |= UInt(_numOfLines) << 4 * UInt(x - 1)
            }
        }
        
        if isFork {
            return Score.win.rawValue
        }
        
        moves = willBeFork ? forkMoves : _movesStack
        var scoreLvl: Float = 0.0
        for x in 1..._numOfColumns {
            let y = Int((moves >> UInt(4 * (x - 1))) & 0xf) + 1;
            if y > _numOfLines {
                continue
            }
            let score = fakeMoveForPlayer(player, atPoint: CGPoint(x: x, y: y))
            if score == .win || _depth >= _maxDepth {
                scoreLvl = scoreLevel(score)
            } else {
                scoreLvl = positionValuationForPlayer(player.nextPlayer(), alpha: -beta, beta: -alpha, isFork: willBeFork)
            }
            cancelMoveForPlayer(player, atPoint: CGPoint(x: x, y: y))
            if scoreLvl > alpha {
                alpha = scoreLvl
            }
            if alpha >= beta {
                return -alpha
            }
        }
        return -alpha
    }
    
    func scoreLevel(_ score: Score) -> Float {
        return score.rawValue * (1.0 - Float(_depth) / Float(_maxDepth) / 10.0)
    }
    
    func fakeMoveForPlayer(_ player: Player, atPoint point:CGPoint) -> Score {
        return .none
    }
    
    func cancelMoveForPlayer(_ player: Player, atPoint point:CGPoint) {
        
    }
    
    func initializeBoard() {
        switch FILGameManager.shared.difficulty {
        case .normal:
            _maxDepth = MaxDepthNormal
        case .hard:
            _maxDepth = MaxDepthHard
        }
        _depth = 0
        _numOfColumns = FILGameManager.shared.numOfColumns
        _numOfLines = FILGameManager.shared.numOfRows
        _firstPlayerWinLine = 0o0
        _firstPlayerForkLine = 0o0
        _secondPlayerWinLine = 0o0
        _secondPlayerForkLine = 0o0
        _movesStack = 0x0
        for i in 0..<WinLineSize {
            _firstPlayerWinLine |= CellStatus.firstPlayer.rawValue << (UInt(i) * CellStatus.step)
            _secondPlayerWinLine |= CellStatus.secondPlayer.rawValue << (UInt(i) * CellStatus.step)
        }
        _firstPlayerWinLine = ((_firstPlayerWinLine >> CellStatus.step) << CellStatus.step) | CellStatus.allowed.rawValue | CellStatus.allowed.rawValue << (UInt(WinLineSize) * CellStatus.step)
        _gameboard = Array(repeating: [], count: 4)
        for i in 0..<4 {
            var linesCount = 0
            switch i {
            case 0:
                linesCount = _numOfColumns
            case 1:
                linesCount = _numOfLines
            default:
                linesCount = _numOfColumns + _numOfLines - 1
            }
            for ii in 0..<linesCount {
                if  (i == 0) ||
                    (i == 2 && ii >= linesCount - _numOfColumns) ||
                    (i == 3 && ii < _numOfColumns) {
                    _gameboard[i].append(CellStatus.allowed.rawValue)
                    continue
                }
                if i == 1 && ii == 0 {
                    var allowedLine = CellStatus.allowed.rawValue
                    for _ in 1..<_numOfColumns {
                        allowedLine = (allowedLine << CellStatus.step) | CellStatus.allowed.rawValue
                    }
                    _gameboard[i].append(allowedLine)
                    continue
                }
                _gameboard[i].append(CellStatus.unallowed.rawValue)
            }
        }
    }
}
