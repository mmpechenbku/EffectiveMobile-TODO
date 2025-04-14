//
//  Date+Formatter.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

import Foundation

extension Date {
    func taskDateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self)
    }
}
