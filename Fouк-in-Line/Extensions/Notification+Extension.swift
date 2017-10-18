//
//  Notification+Extension.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 5/13/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import NotificationCenter

enum UserInfoAttributes {
  static let chipSize = "ChipSize"
  static let contactedWith = "contactedWith"
}

extension Notification.Name {
  static let ItemDropped = Notification.Name("ItemDropped")
  static let NewGameStarted = Notification.Name("NewGameStarted")
  static let ChipSizeChanged = Notification.Name("ChipSizeChanged")
}
