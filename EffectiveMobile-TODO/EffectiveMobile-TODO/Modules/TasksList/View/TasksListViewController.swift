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
        output.didLoadView()
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
            $0.bottom.equalToSuperview()
        }

        footerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(49.0)
        }
    }

    func setupNavBar() {
        let navBarAppearance = UINavigationBarAppearance()

        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .designPalette.black
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.designPalette.white,
            .font: UIFont.systemFont(ofSize: 17.0, weight: .bold)
        ]

        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.designPalette.white,
            .font: UIFont.systemFont(ofSize: 34.0, weight: .bold)
        ]

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.backgroundColor = .designPalette.black

        navigationItem.title = Strings.tasks
        navigationItem.largeTitleDisplayMode = .always

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchBar.tintColor = .designPalette.yellow
        searchController.searchBar.backgroundColor = .designPalette.black
        searchController.searchBar.searchTextField.textColor = .designPalette.white
        searchController.searchBar.searchTextField.backgroundColor = .designPalette.gray

        let liveTextImage = UIImage.designPalette.mic.withTintColor(.designPalette.white)
        searchController.searchBar.setImage(liveTextImage, for: .bookmark, state: [])
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
        footerView.configure(with: text)
    }
}
