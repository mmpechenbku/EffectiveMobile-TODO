//
//  TasksListShimmerView.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 15.04.2025.
//

import UIKit
import SnapKit

final class TasksListShimmerView: UIView, ShimmeringViewProtocol {

    // MARK: - Internal Properties

    var shimmeringAnimatedItems: [UIView] {
        [
            checkmarkView,
            titleView,
            descriptionView,
            dateView
        ]
    }

    // MARK: - Private properties

    private lazy var checkmarkView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.0
        view.backgroundColor = .designPalette.gray
        return view
    }()

    private lazy var titleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6.0
        view.backgroundColor = .designPalette.gray
        return view
    }()

    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8.0
        view.backgroundColor = .designPalette.gray
        return view
    }()

    private lazy var dateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4.0
        view.backgroundColor = .designPalette.gray
        return view
    }()

    private lazy var separatorView = SeparatorView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
      super.layoutSubviews()
        setTemplateWithSubviews(true, viewBackgroundColor: .designPalette.white)
    }
}

// MARK: - Private Methods

private extension TasksListShimmerView {
    func setupUI() {
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        addSubviews([
            checkmarkView,
            titleView,
            descriptionView,
            dateView,
            separatorView
        ])
    }

    func setupConstraints() {
        let maxWidth = UIScreen.main.bounds.width - 20.0 - 20.0

        checkmarkView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.0)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24.0)
            $0.width.equalTo(24.0)
        }

        titleView.snp.makeConstraints {
            $0.top.equalTo(checkmarkView.snp.top)
            $0.leading.equalTo(checkmarkView.snp.trailing).inset(-8.0)
            $0.height.equalTo(22.0)
            $0.width.equalTo(150.0)
        }

        descriptionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).inset(-6.0)
            $0.leading.equalTo(checkmarkView.snp.trailing).inset(-8.0)
            $0.height.equalTo(32.0)
            $0.width.equalTo(maxWidth - 24.0 - 6.0)
        }

        dateView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).inset(-6.0)
            $0.leading.equalTo(checkmarkView.snp.trailing).inset(-8.0)
            $0.height.equalTo(16.0)
            $0.width.equalTo(48.0)
        }

        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
