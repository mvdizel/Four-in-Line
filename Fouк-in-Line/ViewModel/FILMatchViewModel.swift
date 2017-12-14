////
////  FILMatchViewModel.swift
////  Four-in-Line
////
////  Created by Vasilii Muravev on 5/11/17.
////  Copyright © 2017 Vasilii Muravev. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//
//protocol FILMatchViewModelProtocol: class {
//    
//    // MARK: - Attributes
//    var chipAdded: DynamicBinderInterface<FILChipView?> { get }
//    var chipThrown: DynamicBinderInterface<FILChipView?> { get }
//    var chipRemoved: DynamicBinderInterface<FILChipView?> { get }
//    var chipDropped: DynamicBinderInterface<FILChipView?> { get }
//    var removeChips: DynamicBinderInterface<Void> { get }
//    var chipSize: CGFloat { get set }
//    
//    
//    // MARK: - Methods
//    func beganPressing(on position: FILChipPosition)
//    func changedPressing(on position: FILChipPosition)
//    func cancelledPressing(on position: FILChipPosition)
//    func endedPressing(on position: FILChipPosition)
//}
//
///// Private class implementing FILMatchViewModelProtocol
//fileprivate final class FILMatchViewModel {
//    
//    // MARK: Protocol Attributes
//    var chipAdded: DynamicBinderInterface<FILChipView?> {
//        return chipAddedBinder.interface
//    }
//    var chipThrown: DynamicBinderInterface<FILChipView?> {
//        return chipThrownBinder.interface
//    }
//    var chipRemoved: DynamicBinderInterface<FILChipView?> {
//        return chipRemovedBinder.interface
//    }
//    var chipDropped: DynamicBinderInterface<FILChipView?> {
//        return chipDroppedBinder.interface
//    }
//    var removeChips: DynamicBinderInterface<Void> {
//        return removeChipsBinder.interface
//    }
//    var chipSize: CGFloat = 0.0 {
//        didSet {
//            NotificationCenter.default.post(name: .ChipSizeChanged,
//object: nil, userInfo: [UserInfoAttributes.chipSize: chipSize])
//        }
//    }
//    
//    
//    // MARK: - Private Instance Attributes
//    let chipAddedBinder: DynamicBinder<FILChipView?> = DynamicBinder(nil)
//    let chipThrownBinder: DynamicBinder<FILChipView?> = DynamicBinder(nil)
//    let chipRemovedBinder: DynamicBinder<FILChipView?> = DynamicBinder(nil)
//    let chipDroppedBinder: DynamicBinder<FILChipView?> = DynamicBinder(nil)
//    let removeChipsBinder: DynamicBinder<Void> = DynamicBinder(())
//    weak var tempChipView: FILChipView?
//    
//    
//    // MARK: - Initializers
//    init() {
//        setup()
//    }
//}
//
//
//// MARK: - FILMatchViewModelProtocol
//extension FILMatchViewModel: FILMatchViewModelProtocol {
//    func beganPressing(on position: FILChipPosition) {
//        drawTempChipView(on: position)
//    }
//    func changedPressing(on position: FILChipPosition) {
//        drawTempChipView(on: position)
//    }
//    func endedPressing(on position: FILChipPosition) {
//        drawTempChipView(on: position)
//        dropTempChipView()
//    }
//    func cancelledPressing(on position: FILChipPosition) {
//        removeTempChipView()
//    }
//}
//
//
//// MARK: - Private Instance Methods
//fileprivate extension FILMatchViewModel {
//    func setup() {
//        NotificationCenter.default.addObserver(forName: .NewGameStarted,
//object: nil, queue: nil) { [weak self] (notification) in
//            guard let strongSelf = self else { return }
//            strongSelf.removeChipsBinder.value = ()
//        }
//        FILGameManager.shared.tempMoveCondition.bind(with: self) { [weak self] (moveCondition) in
//            guard let strongSelf = self,
//                  let moveCondition = moveCondition else {
//                return
//            }
//            if let _ = strongSelf.tempChipView {
//                return
//            }
//            let chipViewModel = FILViewModelsManager.chipViewModel(for: moveCondition.player,
//at: moveCondition.position)
//            let chipView = FILChipView(frame: CGRect.zero, viewModel: chipViewModel)
//            chipViewModel.configureChip(size: strongSelf.chipSize, motion: false, temporary: true)
//            strongSelf.chipAddedBinder.value = chipView
//            strongSelf.chipAddedBinder.value = nil
//            strongSelf.tempChipView = chipView
//        }
//        FILGameManager.shared.moveCondition.bind(with: self) { [weak self] (moveCondition) in
//            guard let strongSelf = self,
//                  let moveCondition = moveCondition else {
//                return
//            }
//            let chipViewModel = FILViewModelsManager.chipViewModel(for: moveCondition.player,
//at: moveCondition.position)
//            let chipView = FILChipView(frame: CGRect.zero, viewModel: chipViewModel)
//            chipViewModel.configureChip(size: strongSelf.chipSize, motion: true, temporary: false)
//            chipViewModel.isDropped.bind(with: strongSelf, { [weak chipView] (isDropped) in
//                guard let chipDroppedBinder = self?.chipDroppedBinder,
//                      let chipView = chipView else {
//                    return
//                }
//                chipDroppedBinder.value = chipView
//                chipView.viewModel.set(inMotion: false)
//            })
//            strongSelf.chipThrownBinder.value = chipView
//            strongSelf.chipThrownBinder.value = nil
//        }
//    }
//    
//    func drawTempChipView(on position: FILChipPosition) {
//        if let chipView = tempChipView {
//            if chipView.viewModel.position.isEqual(position) {
//                return
//            }
//            removeTempChipView()
//        }
//        FILGameManager.shared.makeTempMove(for: position.column)
//    }
//    
//    func dropTempChipView() {
//        guard let chipView = tempChipView else { return }
//        let column = chipView.viewModel.position.column
//        removeTempChipView()
//        FILGameManager.shared.makeMove(for: column)
//    }
//    
//    func removeTempChipView() {
//        guard let chipView = tempChipView else { return }
//        chipRemovedBinder.value = chipView
//        chipRemovedBinder.value = nil
//        tempChipView = nil
//    }
//}
