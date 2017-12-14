//
//  MatchViewController.swift
//  Four-in-Line
//
//  Created by Vasilii Muravev on 27/08/2017.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

final class MatchViewController: BaseViewController {

  // MARK: - IBOutlets
  @IBOutlet private weak var gameBoardView: GameBoardView!

  // MARK: - Public Instance Attributes

  // MARK: - Private Instance Attributes
  let viewModel = MatchViewModel()
}

// MARK: - IBActions
extension MatchViewController {
  @IBAction func buttonTapped(_ sender: Any) {
    gameBoardView.drop()
  }
}
