//
//  DesignPalette.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit

final class DesignPalette {
    static let shared = DesignPalette()

    let uiColors = UIColors.shared
    let uiImages = UIImages.shared

    private init() {}
}

extension DesignPalette {
    struct UIColors {
        static let shared = UIColors()

        let black = UIColor.rgba(hex: "#040404")
        let white = UIColor.rgba(hex: "#F4F4F4")
        let gray = UIColor.rgba(hex: "#272729")
        let yellow = UIColor.rgba(hex: "#FED702")
        let strokeGray = UIColor.rgba(hex: "#4D555E")
        let red = UIColor.rgba(hex: "#D70015")
        let clear = UIColor.clear

        private init() {}
    }

    struct UIImages {
        static let shared = UIImages()

        let checkmark: UIImage = UIImage(named: "checkmark") ?? UIImage()
        let circle: UIImage = UIImage(named: "circle") ?? UIImage()
        let leftDirectionArrowIcon: UIImage = UIImage(named: "leftDirectionArrowIcon") ?? UIImage()
        let mic: UIImage = UIImage(named: "mic") ?? UIImage()
        let addTask: UIImage = UIImage(named: "addTask") ?? UIImage()
        let edit: UIImage = UIImage(named: "edit") ?? UIImage()
        let share: UIImage = UIImage(named: "export") ?? UIImage()
        let trash: UIImage = UIImage(named: "trash") ?? UIImage()

        private init() {}
    }
}
