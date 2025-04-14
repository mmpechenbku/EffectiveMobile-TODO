//
//  UIColor+RGB.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit

extension UIColor {
    static func rgba(hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            fatalError("Неправильное значение цвета")
        }

        let length = hexSanitized.count

        if length == 6 {
            let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgb & 0x0000FF) / 255.0

            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        } else if length == 8 {
            let red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            let green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            let blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            let alpha = CGFloat(rgb & 0x000000FF) / 255.0

            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            fatalError("Неправильное значение цвета")
        }
    }

    static func rgb(_ rgb: UInt32, alpha: CGFloat = 1) -> UIColor {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0, 0, 0, 0)
    }

    // hue, saturation, brightness and alpha components from UIColor**
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return (hue, saturation, brightness, alpha)
        }
        return (0,0,0,0)
    }

    var hexRGB: String {
        let rgbaCache = rgba
        return String(format: "%02x%02x%02x", Int(round(rgbaCache.red * 255)), Int(round(rgbaCache.green * 255)), Int(round(rgbaCache.blue * 255)))
    }

    var hexRGBA: String {
        let rgbaCache = rgba
        return String(format: "%02x%02x%02x%02x", Int(round(rgbaCache.red * 255)), Int(round(rgbaCache.green * 255)), Int(round(rgbaCache.blue * 255)), Int(round(rgbaCache.alpha * 255)) )
    }
}
