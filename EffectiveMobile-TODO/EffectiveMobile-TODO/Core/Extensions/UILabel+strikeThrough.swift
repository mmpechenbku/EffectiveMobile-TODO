//
//  UILabel+strikeThrough.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import UIKit

extension UILabel {
    func strikeThrough(color: UIColor = .designPalette.white) {
        guard let text = self.text ?? self.attributedText?.string else { return }

        let attributedString: NSMutableAttributedString

        if let existingAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: existingAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: text)
        }

        let range = NSRange(location: 0, length: attributedString.length)

        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: range
        )

        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughColor,
            value: color,
            range: range
        )

        self.attributedText = attributedString
    }

    func removeStrikeThrough() {
        guard let attributedString = self.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }

        attributedString.removeAttribute(
            .strikethroughStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )

        self.attributedText = attributedString
    }
}
