//
//  ChipView.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 10/18/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

final class ChipView: UIView {

  // MARK: - Public Instance Attributes
  let viewModel: ChipViewModel

  // MARK: - Private Instance Attributes
  private let imageView = UIImageView()

  // MARK: - Initializers
  init(viewModel: ChipViewModel) {
    self.viewModel = viewModel
    super.init(frame: viewModel.position.frame)
    setup()
  }

  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    fatalError("unavailable")
  }
}

// MARK: - Private Instance Methods
private extension ChipView {
  func setup() {
    addSubview(imageView)
//    addc
    viewModel.chipSize.bindAndFire(with: self) { [weak self] _ in
      self?.updateFrame()
    }
    viewModel.isTemp.bindAndFire(with: self) { [weak self] isTemp in
      self?.updateFrame()
      self?.alpha = isTemp ? 0.5 : 1.0
    }
//    image = viewModel.image()
    contentMode = .scaleAspectFit
  }

  func updateFrame() {
    var chipFrame = viewModel.position.frame
    if viewModel.isTemp.value {
      chipFrame.origin.y = 0.0
    }
    frame = chipFrame
  }
}
