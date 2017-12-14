////
////  FILChipView.swift
////  Four-in-Line
////
////  Created by Vasilii Muravev on 5/13/17.
////  Copyright © 2017 Vasilii Muravev. All rights reserved.
////
//
//import UIKit
//
//let ChipImageInsets: CGFloat = 2.0
//
//final class FILChipView: UIImageView {
//    
//    // MARK: - Public Instance Attributes
//    let viewModel: FILChipViewModelProtocol
//    
//    
//    // MARK: - Initializers
//    init(frame: CGRect, viewModel: FILChipViewModelProtocol) {
//        self.viewModel = viewModel
//        super.init(frame: frame)
//        setup()
//    }
//    
//    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
//        fatalError("unavailable")
//    }
//    
//    @available(*, unavailable) override init(frame: CGRect) {
//        fatalError("unavailable")
//    }
//    
//    @available(*, unavailable) override init(image: UIImage?) {
//        fatalError("unavailable")
//    }
//    
//    @available(*, unavailable) override init(image: UIImage?, highlightedImage: UIImage?) {
//        fatalError("unavailable")
//    }
//}
//
//
//// MARK: - Private Instance Methods
//fileprivate extension FILChipView {
//    func setup() {
//        viewModel.chipSize.bindAndFire(with: self) { [weak self] (size) in
//            self?.updateFrame()
//        }
//        viewModel.isInMotion.bindAndFire(with: self) { [weak self] (isInMotion) in
//            self?.updateFrame()
//        }
//        viewModel.isTemporary.bindAndFire(with: self) { [weak self] (isTemporary) in
//            self?.updateFrame()
//            self?.alpha = isTemporary ? 0.5 : 1.0
//        }
//        viewModel.isDropped.bindAndFire(with: self) { [weak self] (isDropped) in
//            self?.updateFrame()
//        }
//        image = viewModel.player.image()
//        contentMode = .scaleAspectFit
//        NotificationCenter.default.addObserver(forName: .ItemDropped,
//object: self, queue: nil) { [weak viewModel] (notif) in
//            guard let viewModel = viewModel else { return }
//            guard let secondView = notif.userInfo?[UserInfoAttributes.contactedWith] as? FILChipView else {
//                viewModel.chipDroppedWithContact(of: nil)
//                return
//            }
//            viewModel.chipDroppedWithContact(of: secondView)
//        }
//    }
//    
//    func updateFrame() {
//        let size = viewModel.chipSize.value
//        let x = viewModel.position.point(.inView).x * size + ChipImageInsets
//        var y = viewModel.position.point(.inView).y * size
//        if viewModel.isTemporary.value {
//            y = 0.0
//        } else if viewModel.isInMotion.value {
//            y = frame.origin.y
//        }
//        frame = CGRect(x: x, y: y, width: size - ChipImageInsets * 2, height: size)
//    }
//}
