//
//  TaskDetailPresenter.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import UIKit

// MARK: - Protocols

protocol TaskDetailViewInput: AnyObject {
    func configure(with model: Task?)
    func showError(with text: String)
}

protocol TaskDetailViewOutput: AnyObject {
    var taskTitle: String { get set }
    var taskDescription: String { get set }

    func didLoadView()
    func backButtonDidTapped()
    func saveTask()
}

// MARK: - TaskDetailPresenter

final class TaskDetailPresenter {

    // MARK: - Internal Properties

    weak var view: TaskDetailViewInput?
    let router: TaskDetailRouterProtocol
    let interactor: TaskDetailInteractorProtocol

    var taskTitle: String
    var taskDescription: String

    // MARK: - Private Properties

    private let task: Task?

    // MARK: - Init

    init(
        task: Task? = nil,
        view: TaskDetailViewInput? = nil,
        router: TaskDetailRouterProtocol,
        interactor: TaskDetailInteractorProtocol
    ) {
        self.task = task
        self.view = view
        self.router = router
        self.interactor = interactor

        self.taskTitle = task?.title ?? ""
        self.taskDescription = task?.description ?? ""
    }
}

extension TaskDetailPresenter: TaskDetailViewOutput {
    func didLoadView() {
        view?.configure(with: task)
    }

    func backButtonDidTapped() {
        router.back?()
    }

    func saveTask() {

        guard !taskTitle.isEmpty && !taskDescription.isEmpty else {
            view?.showError(with: Strings.fillAllFieldsErrorDescription)
            return
        }

        if let task {
            let taskToUpdate = Task(id: task.id, title: taskTitle, description: taskDescription, date: task.date, isDone: task.isDone)
            interactor.updateTask(taskToUpdate) { _ in }
        } else {
            let taskToSave = Task(id: UUID().uuidString, title: taskTitle, description: taskDescription, date: Date(), isDone: false)
            interactor.saveTask(taskToSave)
        }

        router.back?()
    }
}
