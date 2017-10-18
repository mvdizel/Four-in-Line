//
//  DropBehavior.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 4/10/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

class DropBehavior: UIDynamicBehavior {
  
  // MARK: - Private Instance Properties
  fileprivate weak var gravityBehavior: UIGravityBehavior!
  fileprivate weak var collisionBehavior: UICollisionBehavior!
  fileprivate weak var itemBehavior: UIDynamicItemBehavior!
  
  
  // MARK: - Initialization
  override init() {
    super.init()
    setupBehaviors()
  }
}


// MARK: - UICollisionBehaviorDelegate
extension DropBehavior: UICollisionBehaviorDelegate {
  func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
    NotificationCenter.default.post(name: .ItemDropped, object: item1, userInfo: [UserInfoAttributes.contactedWith: item2])
    NotificationCenter.default.post(name: .ItemDropped, object: item2, userInfo: [UserInfoAttributes.contactedWith: item1])
  }
  
  func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
    if p.y < 1.0 {
      // do nothing if touched upper border.
      return
    }
    NotificationCenter.default.post(name: .ItemDropped, object: item)
  }
}


// MARK: - Public Instance Methods
extension DropBehavior {
  func add(_ item: UIDynamicItem) {
    gravityBehavior.addItem(item)
    collisionBehavior.addItem(item)
    itemBehavior.addItem(item)
  }
  
  func remove(_ item: UIDynamicItem) {
    gravityBehavior.removeItem(item)
    collisionBehavior.removeItem(item)
    itemBehavior.removeItem(item)
  }
}


// MARK: - Private Instance Methods
private extension DropBehavior {
  func setupBehaviors() {
    addGravityBehavior()
    addCollisionBehavior()
    addItemBehavior()
  }
  
  func addGravityBehavior() {
    let behavior = UIGravityBehavior()
    addChildBehavior(behavior)
    gravityBehavior = behavior
    gravityBehavior.magnitude = 2 // TODO: Play with magnitude
  }
  
  func addCollisionBehavior() {
    let behavior = UICollisionBehavior()
    addChildBehavior(behavior)
    collisionBehavior = behavior
    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    collisionBehavior.collisionDelegate = self
  }
  
  func addItemBehavior() {
    let behavior = UIDynamicItemBehavior()
    addChildBehavior(behavior)
    itemBehavior = behavior
    itemBehavior.allowsRotation = false
  }
}
