//
//  TaskDetailViewController.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import UIKit
import SnapKit

final class TaskDetailViewController: ParentViewController {

    // MARK: - Private Properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .designPalette.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()

    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .designPalette.white
        textView.tintColor = .designPalette.yellow
        textView.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textView.backgroundColor = .designPalette.clear
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.sizeToFit()
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.inputAccessoryView = toolBar
        return textView
    }()

    private lazy var titlePlaceholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = Strings.titlePlaceholder
        placeholderLabel.font = .systemFont(ofSize: 34.0, weight: .bold)
        placeholderLabel.textColor = .designPalette.white.withAlphaComponent(0.5)
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.sizeToFit()
        return placeholderLabel
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.designPalette.white.withAlphaComponent(0.5)
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .designPalette.white
        textView.tintColor = .designPalette.yellow
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .designPalette.clear
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.sizeToFit()
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.inputAccessoryView = toolBar
        return textView
    }()

    private lazy var descriptionPlaceholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = Strings.descriptionPlaceholder
        placeholderLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        placeholderLabel.textColor = .designPalette.white.withAlphaComponent(0.5)
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.sizeToFit()
        return placeholderLabel
    }()

    private lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 35)))
        toolbar.barStyle = .default
        toolbar.isTranslucent = false
        toolbar.tintColor = .designPalette.yellow
        toolbar.sizeToFit()

        let spaceArea = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton = UIBarButtonItem(title: Strings.save, style: .done, target: self, action: #selector(saveButtonDidTapped))

        toolbar.setItems([spaceArea, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        return toolbar
    }()

    private let output: TaskDetailViewOutput

    // MARK: - Init
    init(output: TaskDetailViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.didLoadView()
    }

    // MARK: - Actions

    @objc
    override func backDidTapped() {
        output.backButtonDidTapped()
    }
}

private extension TaskDetailViewController {
    func setupUI() {
        setupNavBar()
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        view.addSubviews([
            scrollView
        ])
        scrollView.addSubviews([
            titleTextView,
            dateLabel,
            descriptionTextView
        ])

        titleTextView.addSubview(titlePlaceholderLabel)
        descriptionTextView.addSubview(descriptionPlaceholderLabel)
    }

    func setupConstraints() {

        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        titleTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(41.0)
            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top).inset(8.0)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20.0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20.0)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width).inset(40.0)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom)
            $0.leading.equalTo(scrollView.contentLayoutGuide.snp.leading).inset(20.0)
        }

        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).inset(-16.0)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20.0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20.0)
            $0.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            $0.height.greaterThanOrEqualTo(22.0)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width).inset(40.0)
        }

        titlePlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview()
        }

        descriptionPlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview()
        }
    }

    func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backBarButton = self.createCustomBarButtonItem(
            image: UIImage.leftDirectionArrowIcon,
            title: Strings.back,
            selector: #selector(backDidTapped)
        )
        navigationItem.leftBarButtonItem = backBarButton
    }

    func showPlaceholdersIfNeeded() {
        if titleTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            titleTextView.text = ""
            titlePlaceholderLabel.isHidden = false
        } else {
            titlePlaceholderLabel.isHidden = true

        }

        if descriptionTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            descriptionTextView.text = ""
            descriptionPlaceholderLabel.isHidden = false

        } else {
            descriptionPlaceholderLabel.isHidden = true
        }
    }

    @objc
    func saveButtonDidTapped() {
        output.saveTask()
    }
}

extension TaskDetailViewController: TaskDetailViewInput {
    func configure(with model: Task?) {
        titleTextView.text = model?.title ?? ""
        dateLabel.text = model?.date.taskDateString() ?? Date().taskDateString()
        descriptionTextView.text = model?.description ?? ""

        showPlaceholdersIfNeeded()
    }

    func showError(with text: String) {
        self.showFlashAlert(with: text)
    }
}

// MARK: - UITextViewDelegate

extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        showPlaceholdersIfNeeded()
        output.taskTitle = titleTextView.text
        output.taskDescription = descriptionTextView.text
    }
}
