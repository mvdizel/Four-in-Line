//
//  UIView+Extension.swift
//  FourInLine
//
//  Created by Vasilii Muravev on 5/13/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

// MARK: - Public Instance Methods
extension UIView {

  /// Returns UIView loaded from `xib` file with same name as owner class name.
  func loadXibView() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nibName = String(describing: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    let nibViews = nib.instantiate(withOwner: self, options: nil)
    guard let view = nibViews.first(where: { $0 is UIView }) as? UIView else {
      return UIView(frame: bounds)
    }
    view.frame = bounds
    addSubview(view)
    autolayoutSize(for: view)
    return view
  }
  
  /// Add constraints to fit the second view size.
  func autolayoutSize(for view: UIView, inset: CGFloat = 0.0) {
    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
    view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset).isActive = true
    view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
    view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset).isActive = true
    view.setNeedsLayout()
  }
}
