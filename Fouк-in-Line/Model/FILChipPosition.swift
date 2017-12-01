////
////  FILChipPosition.swift
////  Four-in-Line
////
////  Created by Vasilii Muravev on 5/14/17.
////  Copyright © 2017 Vasilii Muravev. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//
//enum ChipPositionState {
//  case inView
//  case inBoard
//}
//
//class FILChipPosition:NSObject {
//  
//  // MARK: - Public Instance Attributes
//  var column: Int {
//    return x
//  }
//  
//  
//  // MARK: - Private Instance Attributes
//  fileprivate var state: ChipPositionState
//  fileprivate var x: Int
//  fileprivate var y: Int
//  
//  
//  // MARK: - Initializers
//  init(_ state: ChipPositionState, x: Int, y: Int) {
//    self.x = x
//    self.y = y
//    self.state = state
//  }
//  
//  @available(*, unavailable) private override init() {
//    fatalError("unavailable")
//  }
//}
//
//
//// MARK: Public Instance Methods
//extension FILChipPosition {
//  override func isEqual(_ object: Any?) -> Bool {
//    guard let checkPosition = object as? FILChipPosition else {
//      return false
//    }
//    return point(.inBoard).equalTo(checkPosition.point(.inBoard))
//  }
//  
//  func point(_ state: ChipPositionState) -> CGPoint {
//    if self.state == state {
//      return CGPoint(x: x, y: y)
//    }
//    return CGPoint(x: x, y: FILGameManager.shared.numOfRows - 1 - y)
//  }
//}

