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
        register(TasksListShimmerTableViewCell.self)
        register(TasksListTableViewCell.self)
    }

    func setupDelegates() {
        delegate = self
        dataSource = self
    }

    func setupUI() {
        backgroundColor = UIColor.designPalette.clear
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

        guard let contentModel = output?.findedModels else { return }

        switch contentModel {
        case .loading:
            return
        case .loaded(let models):
            guard models.count > indexPath.row else { return }
            output?.taskDidTapped(models[indexPath.row])
        case .failed:
            return
        }
    }
}

// MARK: - UITableViewDataSource

extension TasksListTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contentModel =  output?.findedModels else { return 0 }

        switch contentModel {
        case .loading:
            return 10
        case .loaded(let models):
            return models.count
        case .failed:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contentModel = output?.findedModels else { return UITableViewCell() }

        switch contentModel {
        case .loading:
            let shimmerCell: TasksListShimmerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return shimmerCell
        case .loaded(let models):
            let cell: TasksListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: models[indexPath.row])
            cell.cellDelegate = self
            return cell
        case .failed:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let contentModel = output?.findedModels else { return 0.0 }

        switch contentModel {
        case .loading:
            return 106.0
        case .loaded:
            return UITableView.automaticDimension
        case .failed:
            return 0.0
        }
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

                switch contentModel {
                case .loading:
                    return nil
                case .loaded(let models):
                    return TasksListCellPreview(model: models[indexPath.row])
                case .failed:
                    return nil
                }
            }
        ) { [weak self] _ in

            let editAction = UIAction(
                title: Strings.edit,
                image: .designPalette.edit.withTintColor(.designPalette.white)
            ) { _ in
                guard let contentModel = self?.output?.findedModels else { return }

                switch contentModel {
                case .loading:
                    return
                case .loaded(let models):
                    guard models.count > indexPath.row else { return }
                    self?.output?.taskDidTapped(models[indexPath.row])
                case .failed:
                    return
                }
            }

            let shareAction = UIAction(
                title: Strings.share,
                image: .designPalette.share.withTintColor(.designPalette.white)
            ) { _ in
                guard let contentModel = self?.output?.findedModels else { return }

                switch contentModel {
                case .loading:
                    return
                case .loaded(let models):
                    guard models.count > indexPath.row else { return }
                    self?.output?.shareTask(models[indexPath.row])
                case .failed:
                    return
                }
            }

            let deleteAction = UIAction(
                title: Strings.delete,
                image: .designPalette.trash,
                attributes: .destructive
            ) { _ in

                guard let contentModel = self?.output?.findedModels else { return }

                switch contentModel {
                case .loading:
                    return
                case .loaded(let models):
                    guard models.count > indexPath.row else { return }
                    self?.output?.deleteTaskDidTapped(with: models[indexPath.row])
                case .failed:
                    return
                }
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

// MARK: - TasksListTableViewCellDelegate

extension TasksListTableView: TasksListTableViewCellDelegate {
    func didTapTaskDone(withId id: String, state: Bool, completion: @escaping (Bool) -> Void) {
        output?.taskDoneDidTapped(withId: id, state: state, completion: completion)
    }
}
