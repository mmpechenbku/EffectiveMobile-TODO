//
//  ParentViewController.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import UIKit

class ParentViewController: UIViewController {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Actions

    @objc
    func backDidTapped() {
        debugPrint(#function)
    }
}

// MARK: - Private Methods

private extension ParentViewController {
    func setupUI() {
        view.backgroundColor = .designPalette.black
    }
}
