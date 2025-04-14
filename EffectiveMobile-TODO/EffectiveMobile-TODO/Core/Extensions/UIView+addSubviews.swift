//
//  UIView+addSubviews.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
