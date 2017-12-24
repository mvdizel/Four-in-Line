//
//  ChipView.swift
//  FourInLine
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


// MARK: - Public Instance Methods
extension ChipView {
  func isSameColumn(as chip: ChipView) -> Bool {
    return viewModel.position.column == chip.viewModel.position.column
  }
}


// MARK: - Private Instance Methods
private extension ChipView {
  func setup() {
    let imageView = UIImageView(frame: bounds)
    self.imageView = imageView
    addSubview(imageView)
    autolayoutSize(for: imageView, inset: 2)
    imageView.image = viewModel.position.player?.image()
    imageView.contentMode = .scaleAspectFit
    viewModel.isTemp.bindAndFire(with: self) { [weak self] isTemp in
      self?.alpha = isTemp ? 0.5 : 1.0
    }
  }
}
