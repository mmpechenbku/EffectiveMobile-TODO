//
//  TaskDetailAssembly.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

final class TaskDetailAssembly {
    static func assembly(with model: Task? = nil) -> (controller: TaskDetailViewController, router: TaskDetailRouterProtocol) {
        let databaseManager = CoreDataManager.shared

        let router = TaskDetailRouter()
        let interactor = TaskDetailInteractor(databaseManager: databaseManager)

        let presenter = TaskDetailPresenter(task: model, router: router, interactor: interactor)
        let view = TaskDetailViewController(output: presenter)

        presenter.view = view
        return (view, router)
    }
}
