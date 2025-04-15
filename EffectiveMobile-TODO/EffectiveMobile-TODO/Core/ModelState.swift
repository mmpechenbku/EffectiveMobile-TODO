//
//  ModelState.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 15.04.2025.
//

import Foundation

enum ModelState<T> {
    case loading
    case loaded(T)
    case failed
}
