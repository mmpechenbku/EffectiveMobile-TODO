//
//  TaskDetailAssembly.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

final class TaskDetailAssembly {
    static func assembly(with model: Task? = nil) -> (controller: TaskDetailViewController, router: TaskDetailRouterProtocol) {
        let router = TaskDetailRouter()
        let presenter = TaskDetailPresenter(task: model, router: router)
        let view = TaskDetailViewController(output: presenter)

        presenter.view = view
        return (view, router)
    }
}
