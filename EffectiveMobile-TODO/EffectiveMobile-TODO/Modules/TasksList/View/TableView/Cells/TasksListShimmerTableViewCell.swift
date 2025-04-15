//
//  TasksListShimmerTableViewCell.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 15.04.2025.
//

import UIKit
import SnapKit

final class TasksListShimmerTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var shimmerView = TasksListShimmerView()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension TasksListShimmerTableViewCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = UIColor.designPalette.clear
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        contentView.addSubview(shimmerView)
    }

    func setupConstraints() {
        shimmerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
