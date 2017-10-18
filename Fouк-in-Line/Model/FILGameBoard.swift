//
//  FILGameBoard.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 5/13/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import CoreGraphics

enum FieldStatus {
    case player(Player)
    case allowed
    case unallowed
    
    func isEmpty() -> Bool {
        switch self {
        case .allowed, .unallowed:
            return true
        default:
            return false
        }
    }
    
    func isAllowed() -> Bool {
        switch self {
        case .allowed:
            return true
        default:
            return false
        }
    }
}

class FILGameBoard {
    
    // MARK: - Singleton
    static let shared = FILGameBoard()
    
    
    // MARK: - Public Instance Attributes
    fileprivate(set) var columns: Int = 0
    fileprivate(set) var rows: Int = 0
    
    
    // MARK: - Private Instance Attributes
    fileprivate var fieldMap: Array<Array<FieldStatus>> = []
    
    
    // MARK: - Initializers
    fileprivate init() {
        // used only as singleton
        // @TODO: Remove after testing
        clearBoard(columns: FILGameManager.shared.numOfColumns, rows: FILGameManager.shared.numOfRows)
    }
}


// MARK: - Public Instance Methods
extension FILGameBoard {
    func clearBoard(columns: Int, rows: Int) {
        fieldMap.removeAll()
        self.columns = columns
        self.rows = rows
        for x in 0..<columns {
            fieldMap.append([])
            for y in 0..<rows {
                fieldMap[x].append(y == 0 ? .allowed : .unallowed)
            }
        }
    }
    
    func status(column x: Int, row y: Int) -> FieldStatus {
        if !fieldMapObtain(x, y) {
            return .unallowed
        }
        return fieldMap[x][y]
    }
    
    func status(column x: Int) -> FieldStatus {
        if !fieldMapObtain(x, 0) {
            return .unallowed
        }
        return status(column: x, row: fieldMap[x].count - 1)
    }
    
    func allowedPosition(column x: Int) -> FILChipPosition? {
        if !fieldMapObtain(x, 0) {
            return nil
        }
        guard let offset = fieldMap[x].enumerated().first(where: { $0.element.isAllowed() })?.offset else {
            return nil
        }
        return FILChipPosition(.inBoard, x: x, y: offset)
    }
    
    func set(_ status: FieldStatus, x: Int, y: Int) {
        if !fieldMapObtain(x, y) {
            return
        }
        fieldMap[x][y] = status
        switch status {
        case .player(_):
            if fieldMapObtain(x, y + 1) {
                fieldMap[x][y + 1] = .allowed
            }
        default:
            break
        }
    }
    
    func set(_ status: FieldStatus, for position: FILChipPosition) {
        set(status, x: Int(position.point(.inBoard).x), y: Int(position.point(.inBoard).y))
    }
}


// MARK: - Private Instance Methods
fileprivate extension FILGameBoard {
    func fieldMapObtain(_ x: Int, _ y: Int) -> Bool {
        if columns == 0 || x < 0 || columns <= x ||
           rows == 0 || y < 0 || rows <= y {
            return false
        }
        return true
    }
}
