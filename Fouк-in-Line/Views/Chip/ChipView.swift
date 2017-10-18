//
//  ChipView.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 10/18/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

class ChipView: UIImageView {
  
  // MARK: - Public Instance Attributes
  let viewModel: ChipViewModel
  
  
  // MARK: - Initializers
  init(frame: CGRect, viewModel: ChipViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    setup()
  }
  
  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    fatalError("unavailable")
  }
  
  @available(*, unavailable) override init(frame: CGRect) {
    fatalError("unavailable")
  }
  
  @available(*, unavailable) override init(image: UIImage?) {
    fatalError("unavailable")
  }
  
  @available(*, unavailable) override init(image: UIImage?, highlightedImage: UIImage?) {
    fatalError("unavailable")
  }
}


// MARK: - Private Instance Methods
private extension ChipView {
  func setup() {
    viewModel.chipSize.bindAndFire(with: self) { [weak self] (size) in
      self?.updateFrame()
    }
    viewModel.isTemp.bindAndFire(with: self) { [weak self] (isTemp) in
      self?.updateFrame()
      self?.alpha = isTemp ? 0.5 : 1.0
    }
//    image = viewModel.image()
    contentMode = .scaleAspectFit
  }

  func updateFrame() {
//    let size = viewModel.chipSize.value
//    let x = viewModel.position.point(.inView).x * size + ChipImageInsets
//    var y = viewModel.position.point(.inView).y * size
//    if viewModel.isTemporary.value {
//      y = 0.0
//    } else if viewModel.isInMotion.value {
//      y = frame.origin.y
//    }
//    frame = CGRect(x: x, y: y, width: size - ChipImageInsets * 2, height: size)
  }
}

