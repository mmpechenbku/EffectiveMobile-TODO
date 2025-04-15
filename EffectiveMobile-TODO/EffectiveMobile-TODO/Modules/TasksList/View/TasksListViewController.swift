//
//  TasksListViewController.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit
import SnapKit

final class TasksListViewController: ParentViewController {

    // MARK: - Private Properties

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .designPalette.black
        return view
    }()

    private let output: TasksListViewOutput
    private let tableView: TasksListTableView

    private let searchController = UISearchController(searchResultsController: nil)
    private let footerView = TasksListFooterView()

    // MARK: - Init

    init(output: TasksListViewOutput, tableView: TasksListTableView) {
        self.output = output
        self.tableView = tableView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.didAppear()
    }
}

// MARK: - Private Methods

private extension TasksListViewController {
    func setupDelegates() {
        searchController.searchBar.delegate = self
        footerView.delegate = self
    }

    func setupUI() {
        view.backgroundColor = .designPalette.gray

        setupNavBar()
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        view.addSubviews([
            contentView
        ])

        contentView.addSubviews([
            tableView,
            footerView
        ])
    }

    func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().inset(20.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalTo(footerView.snp.top)
        }

        footerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(49.0)
        }
    }

    func setupNavBar() {


        navigationItem.title = Strings.tasks
        navigationItem.largeTitleDisplayMode = .always

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchBar.tintColor = .designPalette.yellow
        searchController.searchBar.backgroundColor = .designPalette.black
        searchController.searchBar.searchTextField.textColor = .designPalette.white
        searchController.searchBar.searchTextField.backgroundColor = .designPalette.gray

        let liveTextImageNormal = UIImage.designPalette.mic.withTintColor(.designPalette.white)
        let liveTextImageFocused = UIImage.designPalette.mic.withTintColor(.designPalette.yellow)
        searchController.searchBar.setImage(liveTextImageNormal, for: .bookmark, state: [.normal])
        searchController.searchBar.setImage(liveTextImageFocused, for: .bookmark, state: [.focused])
        searchController.searchBar.showsBookmarkButton = true

        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: searchController.searchBar.searchTextField.placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.designPalette.white.withAlphaComponent(0.5)
            ]
        )

        if let leftView = searchController.searchBar.searchTextField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor.designPalette.white.withAlphaComponent(0.5)
        }
    }
}

// MARK: - UISearchBarDelegate

extension TasksListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output.findTasks(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.findTasks(with: "")
    }
}

// MARK: - TasksListFooterViewDelegate

extension TasksListViewController: TasksListFooterViewDelegate {
    func addNewTask() {
        output.addNewTask()
    }
}

// MARK: - TasksListViewInput

extension TasksListViewController: TasksListViewInput {
    func setupFooter(with text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.footerView.configure(with: text)
        }
    }

    func showDeleteTask(withMessage message: String, title: String, deleteAction: @escaping (() -> Void)) {
        self.deleteAlertController(with: message, title: title, deleteAction: deleteAction)
    }

    func showShareTask(title: String, description: String, dateString: String) {
        let shareString = "\(title):\n\(description)\n\(Strings.date): \(dateString)"
        let shareController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        shareController.popoverPresentationController?.sourceView = self.view
        self.present(shareController, animated: true)
    }

    func showError(withText text: String) {
        self.showFlashAlert(with: text)
    }
}
