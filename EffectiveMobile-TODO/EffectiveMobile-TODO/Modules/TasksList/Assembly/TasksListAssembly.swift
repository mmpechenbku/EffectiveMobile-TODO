//
//  TasksListAssembly.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

final class TasksListAssembly {
    static func assembly() -> (controller: TasksListViewController, router: TasksListRouterProtocol) {
        let networkManager = NetworkManager.shared
        let databaseManager = CoreDataManager.shared

        let router = TasksListRouter()
        let interactor = TasksListInteracotr(networkManager: networkManager, databaseManager: databaseManager)
        let presenter = TasksListPresenter(router: router, interactor: interactor)

        let tableView = TasksListTableView(output: presenter)
        let view = TasksListViewController(output: presenter, tableView: tableView)

        presenter.view = view
        presenter.tableView = tableView
        return (view, router)
    }
}
