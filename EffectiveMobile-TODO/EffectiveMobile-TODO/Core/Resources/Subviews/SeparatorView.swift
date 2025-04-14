//
//  SeparatorView.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import UIKit
import SnapKit

final class SeparatorView: UIView {

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

extension SeparatorView {

    private func setupUI() {
        backgroundColor = UIColor.designPalette.strokeGray
        
        setupConstraints()
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(1.0)
        }
    }
}
