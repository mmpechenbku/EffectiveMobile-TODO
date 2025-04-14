//
//  UIViewController+NavigationBar.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import UIKit

extension UIViewController {
    func createCustomBarButtonItem(image: UIImage, title: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.image = image.withRenderingMode(.alwaysTemplate)
        configuration.title = title
        configuration.image = image
        configuration.imagePadding = 6
        configuration.imagePlacement = .leading

        button.configuration = configuration
        button.tintColor = .designPalette.yellow
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}
