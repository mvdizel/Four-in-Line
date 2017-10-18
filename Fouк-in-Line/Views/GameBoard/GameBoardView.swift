//
//  GameBoardView.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 4/10/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

@IBDesignable final class GameBoardView: UIView {
  
  // MARK: - IBOutlets
  @IBOutlet fileprivate weak var boardView: UIView!
  @IBOutlet fileprivate weak var boardViewAspectRatioConstraint: NSLayoutConstraint! {
    didSet {
      columnsToRowsAspectRatioConstraint = boardViewAspectRatioConstraint
      buildGameBoard()
    }
  }
  
  
  // MARK: - @IBInspectables
  @IBInspectable var numOfColumns: Int {
    get { return Int(boardSize.width) }
    set {
      boardSize.width = CGFloat(max(newValue, 1))
      buildGameBoard()
    }
  }
  @IBInspectable var numOfRows: Int {
    get { return Int(boardSize.height) }
    set {
      boardSize.height = CGFloat(max(newValue, 1))
      buildGameBoard()
    }
  }
  
  
  // MARK: - Public Instance Properties
  weak var viewModel: MatchViewModelProtocol! {
    didSet {
      setup()
    }
  }
  var chipSize: CGFloat {
    return boardView.bounds.width / CGFloat(numOfColumns)
  }
  
  
  // MARK: - Private Instance Properties
  fileprivate var boardSize = CGSize(width: 1, height: 1)
  fileprivate var columnsToRowsAspectRatioConstraint: NSLayoutConstraint!
  fileprivate var animator: UIDynamicAnimator!
  fileprivate var dropBehavior = DropBehavior()
  fileprivate var color: UIColor = .orange
  
  
  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    initializeView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initializeView()
  }
}


// MARK: - Lyfecicle
extension GameBoardView {
  override func layoutSubviews() {
    super.layoutSubviews()
//    viewModel?.chipSize = chipSize
  }
}


// MARK: - @IBActions
extension GameBoardView {
  @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
    guard let _ = viewModel else { return }
    let location = sender.location(in: boardView)
    if location.x < 0 || location.x > boardView.bounds.width {
      viewModel.updateTempChip(column: nil)
      return
    }
    let x = max(0.0, min(boardView.bounds.width - 0.1, location.x))
    let column = Int(x / chipSize)
    switch sender.state {
    case .began, .changed:
      viewModel.updateTempChip(column: column)
    case .ended:
      viewModel.updateTempChip(column: nil)
    case .cancelled, .failed, .possible:
      viewModel.updateTempChip(column: nil)
    }
  }
}


// MARK: - Public Instance Methods
extension GameBoardView {
  func drop() {
    let column = arc4random_uniform(UInt32(numOfColumns))
    let blockSize: CGFloat = boardView.bounds.width / CGFloat(numOfColumns)
    let frame = CGRect(x: CGFloat(column) * blockSize, y: 0.1, width: blockSize, height: blockSize)
    let newView = UIView(frame: frame)
    color = color == UIColor.brown ? UIColor.orange : UIColor.brown
    newView.backgroundColor = color
    boardView.addSubview(newView)
    dropBehavior.add(newView)
    print("column \(column) max column \(numOfColumns)")
  }
}


// MARK: - Private Instance Methods
fileprivate extension GameBoardView {
  func initializeView() {
    addSubview(loadXibView(with: bounds))
    animator = UIDynamicAnimator(referenceView: boardView)
    animator.addBehavior(dropBehavior)
  }
  
  func buildGameBoard() {
    guard let ratioConstraint = columnsToRowsAspectRatioConstraint,
          let _ = boardView,
          numOfRows > 0 else {
      return
    }
    let multiplier = CGFloat(numOfColumns) / CGFloat(numOfRows)
    let newRatioConstraint = ratioConstraint.copy(multiplier: multiplier)
    boardView.removeConstraint(ratioConstraint)
    boardView.addConstraint(newRatioConstraint)
    columnsToRowsAspectRatioConstraint = newRatioConstraint
    boardView.setNeedsLayout()
  }
  
  func setup() {
//    viewModel.chipSize = chipSize
//    viewModel.chipAdded.bind(with: self) { [weak self] (chipView) in
//      guard let boardView = self?.boardView,
//            let chipView = chipView else {
//        return
//      }
//      boardView.addSubview(chipView)
//      boardView.bringSubview(toFront: chipView)
//    }
//    viewModel.chipRemoved.bind(with: self) { (chipView) in
//      guard let chipView = chipView else {
//        return
//      }
//      chipView.removeFromSuperview()
//    }
//    viewModel.chipThrown.bind(with: self) { [weak self] (chipView) in
//      guard let strongSelf = self,
//            let chipView = chipView else {
//        return
//      }
//      strongSelf.boardView.addSubview(chipView)
//      strongSelf.boardView.bringSubview(toFront: chipView)
//      strongSelf.dropBehavior.add(chipView)
//    }
//    viewModel.chipDropped.bind(with: self) { [weak self] (chipView) in
//      guard let strongSelf = self,
//            let chipView = chipView else {
//        return
//      }
//      strongSelf.dropBehavior.remove(chipView)
//    }
//    viewModel.removeChips.bind(with: self) { [weak self] in
//      guard let boardView = self?.boardView else {
//        return
//      }
//      boardView.subviews.forEach({ $0.removeFromSuperview() })
//    }
  }
}
