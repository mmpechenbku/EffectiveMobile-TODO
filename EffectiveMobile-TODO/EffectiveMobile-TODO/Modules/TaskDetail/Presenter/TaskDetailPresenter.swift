//
//  TaskDetailPresenter.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import UIKit

// MARK: - Protocols

protocol TaskDetailViewInput: AnyObject {
    func configure(with model: Task)
}

protocol TaskDetailViewOutput: AnyObject {
    func didLoadView()
    func backButtonDidTapped()
}

// MARK: - TaskDetailPresenter

final class TaskDetailPresenter {

    // MARK: - Internal Properties

    weak var view: TaskDetailViewInput?
    var router: TaskDetailRouterProtocol

    // MARK: - Private Properties

    private let task: Task?

    // MARK: - Init

    init(
        task: Task? = nil,
        view: TaskDetailViewInput? = nil,
        router: TaskDetailRouterProtocol
    ) {
        self.task = task
        self.view = view
        self.router = router
    }
}

extension TaskDetailPresenter: TaskDetailViewOutput {
    func didLoadView() {
        if let task {
            view?.configure(with: task)
        } else {
            let newTask = Task(title: "", description: "", dateString: Date().taskDateString(), isDone: false)
            view?.configure(with: newTask)
        }
    }

    func backButtonDidTapped() {
        router.back?()
    }
}
