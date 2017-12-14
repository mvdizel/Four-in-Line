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
  @IBOutlet private weak var boardView: UIView!
  @IBOutlet private weak var boardViewAspectRatioConstraint: NSLayoutConstraint! {
    didSet {
      columnsToRowsAspectRatioConstraint = boardViewAspectRatioConstraint
      buildGameBoard()
    }
  }
  
  
  // MARK: - @IBInspectables
  @IBInspectable var numOfColumns: Int {
    get {
      return Int(boardSize.width)
    }
    set {
      boardSize.width = CGFloat(max(newValue, 1))
      buildGameBoard()
    }
  }
  @IBInspectable var numOfRows: Int {
    get {
      return Int(boardSize.height)
    }
    set {
      boardSize.height = CGFloat(max(newValue, 1))
      buildGameBoard()
    }
  }
  
  
  // MARK: - Public Instance Properties
  weak var viewModel: MatchViewModel! { didSet { setup() }}
  var chipSize: CGFloat { return DynamicConstants.chipSize.value }
  
  
  // MARK: - Private Instance Properties
  private var boardSize = CGSize(width: 1, height: 1)
  private var columnsToRowsAspectRatioConstraint: NSLayoutConstraint!
  private var animator: UIDynamicAnimator!
  private var dropBehavior = DropBehavior()
  private var color: UIColor = .orange
  private weak var topView: UIView!
  
  
  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    initializeView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initializeView()
  }
  
  
  // MARK: - Lyfecycle
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let chipSize = boardView.bounds.width / CGFloat(numOfColumns)
    DynamicConstants.chipSize.value = chipSize
  }
}


// MARK: - @IBActions
private extension GameBoardView {
  @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
    guard let viewModel = viewModel else { return }
    let location = sender.location(in: boardView)
    guard location.x >= 0, location.x <= boardView.bounds.width else {
      viewModel.updateTempChip(at: nil)
      return
    }
    let x = max(0.0, min(boardView.bounds.width - 0.1, location.x))
    let column = Int(x / chipSize)
    switch sender.state {
    case .began, .changed, .possible:
      viewModel.updateTempChip(at: column)
    case .ended:
      viewModel.updateTempChip(at: nil)
      viewModel.addChip(at: column)
    case .cancelled, .failed:
      viewModel.updateTempChip(at: nil)
    }
  }
}


// MARK: - Public Instance Methods
extension GameBoardView {
  func drop() {
    let column = Int(arc4random_uniform(UInt32(numOfColumns)))
    drop(at: column)
  }
}


// MARK: - Private Instance Methods
private extension GameBoardView {
  func drop(at column: Int) {
    let frame = CGRect(x: CGFloat(column) * chipSize, y: 0.1, width: chipSize, height: chipSize)
    let newView = UIView(frame: frame)
    color = color == UIColor.brown ? UIColor.orange : UIColor.brown
    newView.backgroundColor = color
    boardView.addSubview(newView)
    dropBehavior.add(newView)
  }

  /// Initializes view from nib file.
  func initializeView() {
    topView = loadXibView()
    animator = UIDynamicAnimator(referenceView: boardView)
    animator.addBehavior(dropBehavior)
  }

  /// Builds UI for current gameboard.
  func buildGameBoard() {
    guard let ratioConstraint = columnsToRowsAspectRatioConstraint,
          boardView != nil,
          numOfRows > 0 else {
      return
    }
    let multiplier = CGFloat(numOfColumns) / CGFloat(numOfRows)
    let newRatioConstraint = ratioConstraint.copy(multiplier: multiplier)
    boardView.removeConstraint(ratioConstraint)
    boardView.addConstraint(newRatioConstraint)
    columnsToRowsAspectRatioConstraint = newRatioConstraint
    boardView.setNeedsLayout()
    boardView.layoutIfNeeded()
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
