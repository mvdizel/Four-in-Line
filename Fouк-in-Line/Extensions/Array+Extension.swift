//
//  Array+Extension.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 12/1/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

// MARK: - Subscript
extension Array {
  subscript (safe index: Int) -> Element? {
    return index < count ? self[index] : nil
  }
}
