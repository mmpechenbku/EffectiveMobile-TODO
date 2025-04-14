//
//  TasksListTableViewCell.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit
import SnapKit

final class TasksListTableViewCell: UITableViewCell {

    // MARK: - Private properties

    private lazy var checkmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.designPalette.circle, for: .normal)
        button.backgroundColor = .designPalette.clear
        button.tintColor = .designPalette.strokeGray
        button.addTarget(self, action: #selector(checkMarkButtonDidTapped), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.designPalette.white
        label.numberOfLines = 1
        return label
    }()

    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.designPalette.white
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.designPalette.white
        label.numberOfLines = 1
        return label
    }()

    private lazy var taskStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6.0
        stack.alignment = .top
        stack.distribution = .fill
        stack.addArrangedSubviews([titleLabel, taskLabel, dateLabel])
        return stack
    }()

    private lazy var separatorView = SeparatorView()

    private var isDone: Bool = false

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - prepareForReuse

    override func prepareForReuse() {
        super.prepareForReuse()
        setToDefault()
    }

    // MARK: - Internal Methods

    func configure(with model: Task) {
        titleLabel.text = model.title
        taskLabel.text = model.description
        dateLabel.text = model.dateString

        model.isDone ? taskIsDone() : setToDefault()
    }
}

// MARK: - Private Methods

private extension TasksListTableViewCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = UIColor.designPalette.clear

        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        contentView.addSubviews([
            checkmarkButton,
            taskStack,
            separatorView
        ])
    }

    func setupConstraints() {
        checkmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.0)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24.0)
            $0.width.equalTo(24.0)
        }

        taskStack.snp.makeConstraints {
            $0.top.equalTo(checkmarkButton.snp.top)
            $0.leading.equalTo(checkmarkButton.snp.trailing).inset(-8.0)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12.0)
        }

        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func taskIsDone() {
        isDone = true
        checkmarkButton.setImage(.designPalette.checkmark, for: .normal)
        checkmarkButton.tintColor = .designPalette.yellow

        titleLabel.strikeThrough(color: titleLabel.textColor)
        titleLabel.layer.opacity = 0.5
        taskLabel.textColor = taskLabel.textColor.withAlphaComponent(0.5)
        dateLabel.textColor = dateLabel.textColor.withAlphaComponent(0.5)
    }

    func setToDefault() {
        isDone = false
        checkmarkButton.setImage(.designPalette.circle, for: .normal)
        checkmarkButton.tintColor = .designPalette.strokeGray

        titleLabel.removeStrikeThrough()
        titleLabel.layer.opacity = 1
        taskLabel.textColor = .designPalette.white
        dateLabel.textColor = .designPalette.white
    }

    // MARK: - Actions

    @objc
    func checkMarkButtonDidTapped() {
        isDone ? setToDefault() : taskIsDone()
    }
}
