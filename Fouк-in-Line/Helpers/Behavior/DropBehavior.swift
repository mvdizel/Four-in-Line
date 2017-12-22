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
  private weak var gravityBehavior: UIGravityBehavior!
  private weak var collisionBehavior: UICollisionBehavior!
  private var itemBehaviors: [Weak<UIDynamicItemBehavior>] = []

  
  // MARK: - Initialization
  override init() {
    super.init()
    setupBehaviors()
  }
}


// MARK: - UICollisionBehaviorDelegate
extension DropBehavior: UICollisionBehaviorDelegate {
  // swiftlint:disable identifier_name
  func collisionBehavior(_ behavior: UICollisionBehavior,
                         beganContactFor item1: UIDynamicItem,
                         with item2: UIDynamicItem,
                         at p: CGPoint) {
    NotificationCenter.default.post(
      name: .ItemDropped,
      object: item1,
      userInfo: [UserInfoAttributes.contactedWith: item2]
    )
    NotificationCenter.default.post(
      name: .ItemDropped,
      object: item2,
      userInfo: [UserInfoAttributes.contactedWith: item1]
    )
    guard let chip1 = item1 as? ChipView,
          let chip2 = item2 as? ChipView,
          chip1.isSameColumn(as: chip2) else {
      return
    }
    anchor(item1)
    anchor(item2)
  }

  func collisionBehavior(_ behavior: UICollisionBehavior,
                         beganContactFor item: UIDynamicItem,
                         withBoundaryIdentifier identifier: NSCopying?,
                         at p: CGPoint) {
    if p.y < 1.0 {
      // do nothing if touched upper border.
      return
    }
    anchor(item)
    NotificationCenter.default.post(name: .ItemDropped, object: item)
  }
  // swiftlint:enable identifier_name
}


// MARK: - Public Instance Methods
extension DropBehavior {
  func add(_ chip: ChipView) {
    gravityBehavior.addItem(chip)
    collisionBehavior.addItem(chip)
    addItemBehavior(with: chip)
  }
  
  func updateBoundaries(with frame: CGRect) {
    collisionBehavior.removeAllBoundaries()
    let porintFrom = CGPoint(x: 0, y: frame.height)
    let porintTo = CGPoint(x: frame.width, y: frame.height)
    collisionBehavior.addBoundary(
      withIdentifier: NSString(string: "bottom"),
      from: porintFrom,
      to: porintTo
    )
  }
}


// MARK: - Private Instance Methods
private extension DropBehavior {
  func setupBehaviors() {
    addGravityBehavior()
    addCollisionBehavior()
  }
  
  func addGravityBehavior() {
    let behavior = UIGravityBehavior()
    addChildBehavior(behavior)
    gravityBehavior = behavior
    // @TODO: Play with magnitude
    gravityBehavior.magnitude = 1.5
  }
  
  func addCollisionBehavior() {
    let behavior = UICollisionBehavior()
    addChildBehavior(behavior)
    collisionBehavior = behavior
    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    collisionBehavior.collisionDelegate = self
    collisionBehavior.collisionMode = .everything
  }
  
  func addItemBehavior(with item: UIDynamicItem) {
    let behavior = UIDynamicItemBehavior()
    addChildBehavior(behavior)
    itemBehaviors.append(Weak(behavior))
    behavior.allowsRotation = false
    behavior.addItem(item)
  }
  
  func anchor(_ item: UIDynamicItem) {
    guard let chip = item as? ChipView else {
      return
    }
    guard let itemBehavior = itemBehaviors.first(where: {
      ($0.value?.items.first as? ChipView) == chip
    })?.value, !itemBehavior.isAnchored else {
      return
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
      guard !itemBehavior.isAnchored else {
        return
      }
      itemBehavior.isAnchored = true
      chip.frame = chip.viewModel.position.frame
      self?.dynamicAnimator?.updateItem(usingCurrentState: chip)
    }
  }
  
  func isItemAnchored(_ item: UIDynamicItem) -> Bool {
    guard let chip = item as? ChipView else {
      return false
    }
    guard let itemBehavior = itemBehaviors.first(where: {
      ($0.value?.items.first as? ChipView) == chip
    })?.value else {
      return false
    }
    return itemBehavior.isAnchored
  }
}
