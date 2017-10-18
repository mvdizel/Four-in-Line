//
//  UIView+Extension.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 5/13/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

extension UIView {
  
  /// Returns UIView loaded from `xib` file with same name as owner class name.
  func loadXibView(with rext: CGRect) -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nibName = String(describing: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    let nibViews = nib.instantiate(withOwner: self, options: nil)
    for nibObject in nibViews {
      guard let view = nibObject as? UIView else { continue }
      view.frame = rext
      view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      return view
    }
    return UIView()
  }
}
