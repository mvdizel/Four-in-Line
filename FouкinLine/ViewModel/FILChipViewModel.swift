////
////  FILChipViewModel.swift
////  FourInLine
////
////  Created by Vasilii Muravev on 5/13/17.
////  Copyright © 2017 Vasilii Muravev. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol FILChipViewModelProtocol: class {
//    
//    // MARK: - Attributes
//    var player: Player { get }
//    var position: FILChipPosition { get }
//    var chipSize: DynamicBinderInterface<CGFloat> { get }
//    var isInMotion: DynamicBinderInterface<Bool> { get }
//    var isTemporary: DynamicBinderInterface<Bool> { get }
//    var isDropped: DynamicBinderInterface<Bool> { get }
//    
//    
//    // MARK: - Methods
//    func configureChip(size: CGFloat, motion: Bool, temporary: Bool)
//    func set(chipSize: CGFloat)
//    func set(inMotion: Bool)
//    func set(temporary: Bool)
//    func chipDroppedWithContact(of chipView: FILChipView?)
//}
//
///// Private class implementing FILChipViewModelProtocol
//fileprivate final class FILChipViewModel {
//    
//    // MARK: Protocol Attributes
//    let player: Player
//    let position: FILChipPosition
//    var chipSize: DynamicBinderInterface<CGFloat> {
//        return chipSizeBinder.interface
//    }
//    var isInMotion: DynamicBinderInterface<Bool> {
//        return isInMotionBinder.interface
//    }
//    var isTemporary: DynamicBinderInterface<Bool> {
//        return isTemporaryBinder.interface
//    }
//    var isDropped: DynamicBinderInterface<Bool> {
//        return isDroppedBinder.interface
//    }
//    
//    
//    // MARK: - Private Instance Attributes
//    fileprivate let chipSizeBinder: DynamicBinder<CGFloat> = DynamicBinder(0.0)
//    fileprivate let isInMotionBinder: DynamicBinder<Bool> = DynamicBinder(false)
//    fileprivate let isTemporaryBinder: DynamicBinder<Bool> = DynamicBinder(true)
//    fileprivate let isDroppedBinder: DynamicBinder<Bool> = DynamicBinder(false)
//    fileprivate var dropBinderFired: Bool = false
//    
//    
//    // MARK: - Initializers
//    init(for player: Player, at position: FILChipPosition) {
//        self.player = player
//        self.position = position
//        NotificationCenter.default.addObserver(forName: .ChipSizeChanged,
//object: nil, queue: nil) { [weak self] (notif) in
//            guard let strongSelf = self,
//                  let chipSize = notif.userInfo?[UserInfoAttributes.chipSize] as? CGFloat else {
//                return
//            }
//            strongSelf.set(chipSize: chipSize)
//        }
//    }
//}
//
//
//// MARK: - FILChipViewModelProtocol
//extension FILChipViewModel: FILChipViewModelProtocol {
//    func set(chipSize: CGFloat) {
//        chipSizeBinder.value = chipSize
//    }
//    
//    func set(inMotion: Bool) {
//        isInMotionBinder.value = inMotion
//    }
//    
//    func set(temporary: Bool) {
//        isTemporaryBinder.value = temporary
//    }
//    
//    func configureChip(size: CGFloat, motion: Bool, temporary: Bool) {
//        set(chipSize: size)
//        set(inMotion: motion)
//        set(temporary: temporary)
//    }
//    
//    func chipDroppedWithContact(of chipView: FILChipView?) {
//        if isDropped.value || dropBinderFired {
//            return
//        }
//        if let secondViewModel = chipView?.viewModel,
//               secondViewModel.position.column != position.column || secondViewModel.isInMotion.value {
//            return
//        }
//        dropBinderFired = true
//        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.5) { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.isDroppedBinder.value = true
//        }
//    }
//}
