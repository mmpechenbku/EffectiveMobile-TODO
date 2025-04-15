//
//  TasksListTableViewCell.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit
import SnapKit

protocol TasksListTableViewCellDelegate: AnyObject {
    func didTapTaskDone(withId id: String, state: Bool, completion: @escaping (Bool) -> Void)
}

final class TasksListTableViewCell: UITableViewCell {

    // MARK: - Internal Properties

    weak var cellDelegate: TasksListTableViewCellDelegate?

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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.designPalette.white
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        return label
    }()

    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.designPalette.white
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh - 1, for: .vertical)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.designPalette.white.withAlphaComponent(0.5)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
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

    private var isDone: Bool = false {
        didSet {
            isDone ? completedTask() : uncompletedTask()
        }
    }

    private var id: String = ""

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
//        uncompletedTask()
        id = ""
        isDone = false
        titleLabel.text = nil
        taskLabel.text = nil
        dateLabel.text = nil
    }

    // MARK: - Internal Methods

    func configure(with model: Task) {
        id = model.id
        titleLabel.text = model.title
        taskLabel.text = model.description
        dateLabel.text = model.date.taskDateString()

        model.isDone ? completedTask() : uncompletedTask()
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

    func completedTask() {
//        isDone = true
        checkmarkButton.setImage(.designPalette.checkmark, for: .normal)
        checkmarkButton.tintColor = .designPalette.yellow

        titleLabel.strikeThrough(color: titleLabel.textColor)
        titleLabel.layer.opacity = 0.5
        taskLabel.textColor = taskLabel.textColor.withAlphaComponent(0.5)
//        dateLabel.textColor = dateLabel.textColor.withAlphaComponent(0.5)
    }

    func uncompletedTask() {
//        isDone = false
        checkmarkButton.setImage(.designPalette.circle, for: .normal)
        checkmarkButton.tintColor = .designPalette.strokeGray

        titleLabel.removeStrikeThrough()
        titleLabel.layer.opacity = 1
        taskLabel.textColor = .designPalette.white
//        dateLabel.textColor = .designPalette.white
    }

    // MARK: - Actions

    @objc
    func checkMarkButtonDidTapped() {
        if !id.isEmpty {
            cellDelegate?.didTapTaskDone(withId: id, state: !isDone) { [weak self] isDone in
                DispatchQueue.main.async {
                    self?.isDone = isDone
                }
            }
        }
    }
}
