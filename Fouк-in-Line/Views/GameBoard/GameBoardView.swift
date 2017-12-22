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
  @IBOutlet private weak var firstPlayerImageView: UIImageView!
  @IBOutlet private weak var secondPlayerImageView: UIImageView!
  @IBOutlet private weak var secondPlayerSpinner: UIActivityIndicatorView!
  
  
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
  weak var viewModel: MatchViewModel! {
    didSet {
      setup()
    }
  }
  var chipSize: CGFloat {
    return DynamicConstants.chipSize.value
  }
  
  
  // MARK: - Private Instance Properties
  private var boardSize = CGSize(width: 1, height: 1)
  private var columnsToRowsAspectRatioConstraint: NSLayoutConstraint!
  private var animator: UIDynamicAnimator!
  private var dropBehavior = DropBehavior()
  private var color: UIColor = .orange
  private weak var topView: UIView!
  private weak var tempChipView: ChipView?
  private var chipViews: [Weak<ChipView>] = []
  
  
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
    dropBehavior.updateBoundaries(with: boardView.frame)
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
    viewModel.addChip(at: column)
  }
}


// MARK: - Private Instance Methods
private extension GameBoardView {

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
  
  /// Setups view model
  func setup() {
    viewModel.chipAdded.bind(with: self) { [weak self] chipViewModel in
      DispatchQueue.main.async {
        self?.process(new: chipViewModel)
      }
    }
    viewModel.tempChip.bind(with: self) { [weak self] chipViewModel in
      DispatchQueue.main.async {
        self?.process(temp: chipViewModel)
      }
    }
    viewModel.gameStarted.bind(with: self) { [weak self] in
      DispatchQueue.main.async {
        self?.startNewGame()
      }
    }
    viewModel.currentPlayer.bindAndFire(with: self) { [weak self] currentPlayer in
      DispatchQueue.main.async {
        self?.process(currentPlayer)
      }
    }
  }
  
  func process(new chipViewModel: ChipViewModel?) {
    guard let chipViewModel = chipViewModel else {
      return
    }
    let chipView = ChipView(viewModel: chipViewModel)
    var frame = chipViewModel.position.frame
    frame.origin.y = 0.0
    chipView.frame = frame
    chipViews.append(Weak(chipView))
    boardView.insertSubview(chipView, at: 0)
    dropBehavior.add(chipView)
  }
  
  func process(temp chipViewModel: ChipViewModel?) {
    tempChipView?.removeFromSuperview()
    guard let chipViewModel = chipViewModel else {
      return
    }
    let chipView = ChipView(viewModel: chipViewModel)
    var frame = chipViewModel.position.frame
    frame.origin.y = 0.0
    chipView.frame = frame
    tempChipView = chipView
    boardView.insertSubview(chipView, at: 0)
  }
  
  func process(_ currentPlayer: Player) {
    let isFirst = currentPlayer == .human
    firstPlayerImageView.alpha = isFirst ? 1.0 : 0.4
    secondPlayerImageView.alpha = isFirst ? 0.4 : 1.0
    isUserInteractionEnabled = isFirst
    if isFirst {
      secondPlayerSpinner.stopAnimating()
    } else {
      secondPlayerSpinner.startAnimating()
    }
  }
  
  func startNewGame() {
    tempChipView?.removeFromSuperview()
    chipViews.flatMap({ $0.value }).forEach { chipView in
      chipView.removeFromSuperview()
    }
    let dropBehavior = DropBehavior()
    dropBehavior.updateBoundaries(with: boardView.frame)
    animator.removeAllBehaviors()
    animator.addBehavior(dropBehavior)
    self.dropBehavior = dropBehavior
  }
}
