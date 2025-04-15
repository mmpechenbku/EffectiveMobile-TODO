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

        setupNavBar()
    }

    func setupNavBar() {
        let navBarAppearance = UINavigationBarAppearance()

        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .designPalette.black
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.designPalette.white,
            .font: UIFont.systemFont(ofSize: 17.0, weight: .bold)
        ]

        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.designPalette.white,
            .font: UIFont.systemFont(ofSize: 34.0, weight: .bold)
        ]

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.backgroundColor = .designPalette.black
    }
}
