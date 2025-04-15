//
//  ShimmeringViewProtocol.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 15.04.2025.
//

import UIKit

public protocol ShimmeringViewProtocol where Self: UIView {
    var shimmeringAnimatedItems: [UIView] { get }
    var excludedItems: Set<UIView> { get }
}

extension ShimmeringViewProtocol {
    public var shimmeringAnimatedItems: [UIView] { [self] }
    public var excludedItems: Set<UIView> { [] }
}
