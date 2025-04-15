//
//  TasksListFooterView.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import UIKit
import SnapKit

protocol TasksListFooterViewDelegate: AnyObject {
    func addNewTask()
}

final class TasksListFooterView: UIView {

    // MARK: - Internal Properties

    weak var delegate: TasksListFooterViewDelegate?

    // MARK: - Private Properties

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .designPalette.white
        label.numberOfLines = 1
        return label
    }()

    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.designPalette.addTask, for: .normal)
        button.backgroundColor = .designPalette.clear
        button.tintColor = .designPalette.yellow
        button.addTarget(self, action: #selector(didAddNewTaskTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func configure(with text: String) {
        countLabel.text = text
    }
}

// MARK: - Private Methods

private extension TasksListFooterView {
    func setupUI() {
        backgroundColor = .designPalette.gray
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        addSubviews([
            countLabel,
            addTaskButton
        ])
    }

    func setupConstraints() {
        countLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        addTaskButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5.0)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(44.0)
            $0.width.equalTo(68.0)
        }
    }

    // MARK: - Actions

    @objc
    func didAddNewTaskTapped() {
        delegate?.addNewTask()
    }
}
