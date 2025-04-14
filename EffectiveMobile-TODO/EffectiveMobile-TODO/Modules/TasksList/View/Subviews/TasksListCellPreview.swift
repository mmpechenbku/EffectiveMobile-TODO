//
//  TasksListCellPreview.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 14.04.2025.
//

import UIKit
import SnapKit

final class TasksListCellPreview: UIViewController {

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Почитать книгу"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.designPalette.white
        label.numberOfLines = 1
        return label
    }()

    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.designPalette.white
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "09/10/24"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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

    private let model: Task

    // MARK: - Init

    init(model: Task) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        setupUI()
        preferredContentSize = CGSize(width: getWidth(), height: getHeight())
    }
}

private extension TasksListCellPreview {
    func setupUI() {
        view.backgroundColor = .designPalette.gray
        configure(with: model)
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        view.addSubviews([
            taskStack
        ])
    }

    func setupConstraints() {
        taskStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
    }

    func configure(with model: Task) {
        titleLabel.text = model.title
        taskLabel.text = model.description
        dateLabel.text = model.dateString
    }

    func getWidth() -> CGFloat {
        return view.bounds.width - 20.0 - 20.0
    }

    func getHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height += 12.0 // top inset

        height += titleLabel.text?.height(
            withConstrainedWidth: view.bounds.width - 16.0 - 16.0,
            font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ) ?? 0.0

        height += 6.0 // stack spacing

        height += taskLabel.text?.height(
            withConstrainedWidth: view.bounds.width - 16.0 - 16.0,
            font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ) ?? 0.0

        height += 6.0 // stack spacing

        height += dateLabel.text?.height(
            withConstrainedWidth: view.bounds.width - 16.0 - 16.0,
            font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ) ?? 0.0

        height += 12.0 // bottom inset

        return height
    }
}
