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
  private weak var imageView: UIImageView!

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
    viewModel.chipSize.bindAndFire(with: self) { [weak self] _ in
      self?.updateFrame()
    }
    viewModel.isTemp.bindAndFire(with: self) { [weak self] isTemp in
      self?.updateFrame()
      self?.alpha = isTemp ? 0.5 : 1.0
    }
    let imageView = UIImageView()
    self.imageView = imageView
    addSubview(imageView)
    imageView.image = viewModel.position.player?.image()
    imageView.contentMode = .scaleAspectFit
  }

  func updateFrame() {
    var chipFrame = viewModel.position.frame
    if viewModel.isTemp.value {
      chipFrame.origin.y = 0.0
    }
    frame = chipFrame
    // @TODO: Use autolayout.
    let imageInset: CGFloat = 0.1
    var imageFrame = bounds
    imageFrame.origin.x = bounds.width * imageInset
    imageFrame.origin.y = bounds.height * imageInset
    imageFrame.size.width = bounds.width * (1.0 - imageInset * 2.0)
    imageFrame.size.height = bounds.height * (1.0 - imageInset * 2.0)
    imageView.frame = imageFrame
  }
}
