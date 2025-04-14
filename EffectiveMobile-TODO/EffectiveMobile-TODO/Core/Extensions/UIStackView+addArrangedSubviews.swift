//
//  UIStackView+addArrangedSubviews.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }

    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([UIView]()) { allSubviews, subview in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        let constraints = removedSubviews.flatMap { $0.constraints }
        NSLayoutConstraint.deactivate(constraints)

        for removedSubview in removedSubviews where removedSubview.superview != nil {
            removedSubview.removeFromSuperview()
        }
    }
}
