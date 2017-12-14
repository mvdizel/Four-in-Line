//
//  UIView+Extension.swift
//  Four-in-Line
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
    topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    return view
  }
}
