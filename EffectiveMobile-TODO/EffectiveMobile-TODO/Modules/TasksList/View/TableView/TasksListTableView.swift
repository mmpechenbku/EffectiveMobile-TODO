//
//  TasksListTableView.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit

final class TasksListTableView: UITableView {

    // MARK: - Private properties

    private weak var output: TasksListTableViewOutput?

    // MARK: - Init

    init(output: TasksListTableViewOutput) {
        self.output = output
        super.init(frame: .zero, style: .grouped)
        registerCells()
        setupDelegates()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension TasksListTableView {
    func registerCells() {
        register(TasksListTableViewCell.self)
    }

    func setupDelegates() {
        delegate = self
        dataSource = self
    }

    func setupUI() {
        backgroundColor = UIColor.designPalette.clear
//        separatorStyle = .singleLine
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = UITableView.automaticDimension
    }
}

// MARK: - TasksListTableViewInput

extension TasksListTableView: TasksListTableViewInput {
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate

extension TasksListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        output?.taskDidTapped(withIndex: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension TasksListTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contentModel = output?.findedModels else { return 0 }

        return contentModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contentModel = output?.findedModels else { return UITableViewCell() }

        let cell: TasksListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: contentModel[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.0
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {

        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] () -> UIViewController? in
                guard let contentModel = self?.output?.findedModels else { return nil }

                return TasksListCellPreview(model: contentModel[indexPath.row])
            }
        ) { [weak self] _ in

            let editAction = UIAction(
                title: Strings.edit,
                image: .designPalette.edit.withTintColor(.designPalette.white)
            ) { _ in
                self?.output?.taskDidTapped(withIndex: indexPath.row)
            }

            let shareAction = UIAction(
                title: Strings.share,
                image: .designPalette.share.withTintColor(.designPalette.white)
            ) { _ in

            }

            let deleteAction = UIAction(
                title: Strings.delete,
                image: .designPalette.trash,
                attributes: .destructive
            ) { _ in

            }

            let menu = UIMenu(
                title: "",
                image: nil,
                options: UIMenu.Options.displayInline,
                children: [editAction, shareAction, deleteAction]
            )

            return menu
        }

        return config
    }
}
