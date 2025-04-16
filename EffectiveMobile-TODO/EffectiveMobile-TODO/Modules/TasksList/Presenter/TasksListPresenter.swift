//
//  TasksListPresenter.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

// MARK: - Protocols

import Foundation

protocol TasksListViewInput: AnyObject {
    func setupFooter(with text: String)
    func showDeleteTask(withMessage message: String, title: String, deleteAction: @escaping (() -> Void))
    func showShareTask(title: String, description: String, dateString: String)
    func showError(withText text: String)
}

protocol TasksListViewOutput: AnyObject {
    func didAppear()
    func findTasks(with text: String)
    func addNewTask()
}

protocol TasksListTableViewInput: AnyObject {
    func refreshData()
}

protocol TasksListTableViewOutput: AnyObject {
    var findedModels: ModelState<[Task]>? { get set }

    func updateContentModel(completion: @escaping () -> Void)
    func taskDidTapped(_ task: Task)
    func taskDoneDidTapped(withId id: String, state: Bool, completion: @escaping (Bool) -> Void)
    func deleteTaskDidTapped(with task: Task)
    func shareTask(_ task: Task)
}

// MARK: - TasksListPresenter

final class TasksListPresenter {

    // MARK: - Internal Properties

    var findedModels: ModelState<[Task]>? {
        didSet {
            tableView?.refreshData()
            configureFooter()
        }
    }

    weak var view: TasksListViewInput?
    weak var tableView: TasksListTableViewInput?
    let router: TasksListRouterProtocol
    let interactor: TasksListInteractorProtocol

    // MARK: - Private Properties

    var contentModel: [Task]? = nil {
        didSet {
            if let contentModel {
                findedModels = .loaded(contentModel)
            } else {
                findedModels = .loading
            }
            findTasks(with: searchText)
        }
    }

    var searchText: String = ""

    // MARK: - Init

    init(
        view: TasksListViewInput? = nil,
        tableView: TasksListTableViewInput? = nil,
        router: TasksListRouterProtocol,
        interactor: TasksListInteractorProtocol
    ) {
        self.view = view
        self.tableView = tableView
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - Private Methods

private extension TasksListPresenter {
    func setupContentModel(completion: @escaping () -> Void) {
        findedModels = .loading
        if interactor.getApiDataAlreadyLoadedState() {
            loadDataFromDatabase(completion: completion)
        } else {
            loadAndSaveDataFromAPI(completion: completion)
        }
    }

    func configureFooter() {

        var footerText = ""

        switch findedModels {
        case .loading:
            footerText = Strings.loading
        case .loaded(let models):
            let countText = getCountText(from: models.count)
            footerText = "\(models.count) \(countText)"

            if !searchText.isEmpty {
                footerText = "Найдено \(footerText)"
            }
        case .failed, .none:
            footerText = Strings.error
        }

        view?.setupFooter(with: footerText)
    }

    func getCountText(from count: Int) -> String {
        if (11...14).contains(count % 10) {
            return "Задач"
        }
        switch count % 10 {
        case 1:
            return "Задача"
        case 2...4:
            return "Задачи"
        default:
            return "Задач"
        }
    }

    func deleteTask(_ task: Task) {
        interactor.deleteTask(task) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let isDeleted):
                if isDeleted {
                    setupContentModel() {}
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.showError(withText: Strings.taskDoesntExistError)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showError(withText: error.localizedDescription)
                }
            }
        }
    }

    func loadDataFromDatabase(completion: @escaping () -> Void) {
        interactor.obtainTasksFromDataBase { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                contentModel = tasks
            case .failure(let error):
                findedModels = .failed
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showError(withText: error.localizedDescription)
                }
            }
            completion()
        }
    }

    func loadAndSaveDataFromAPI(completion: @escaping () -> Void) {
        interactor.obtainTasksFromNet { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                contentModel = tasks
                interactor.saveTasks(tasks) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let isSaved):
                        if isSaved {
                            interactor.setApiDataLoadingState(with: isSaved)
                        }
                    case .failure(let error):
                        findedModels = .failed
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.showError(withText: error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                findedModels = .failed
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showError(withText: error.localizedDescription)
                }
            }
            completion()
        }
    }
}

// MARK: - TasksListViewInput

extension TasksListPresenter: TasksListViewOutput {

    func didAppear() {
        setupContentModel() {}
    }

    func findTasks(with text: String) {
        searchText = text

        guard !text.isEmpty else {
            if let contentModel {
                findedModels = .loaded(contentModel)
            } else {
                findedModels = .loading
            }
            return
        }

        findedModels = .loading

        var satisfyingTasks: [Task] = []

        contentModel?.forEach { task in
            guard
                task.title.lowercased().contains(text.lowercased()) || task.description.lowercased().contains(text.lowercased())
            else { return }

            satisfyingTasks.append(task)
        }

        findedModels = .loaded(satisfyingTasks)
    }

    func addNewTask() {
        router.toDetailTask?(nil)
    }
}

// MARK: - TasksListTableViewInput

extension TasksListPresenter: TasksListTableViewOutput {
    func updateContentModel(completion: @escaping () -> Void) {
        setupContentModel {
            completion()
        }
    }

    func taskDidTapped(_ task: Task) {
        router.toDetailTask?(task)
    }

    func taskDoneDidTapped(withId id: String, state: Bool, completion: @escaping (Bool) -> Void) {
        interactor.updateTaskDoneState(withId: id, state: state) { result in
            switch result {
            case .success(let doneState):
                completion(doneState)
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showError(withText: error.localizedDescription)
                }
            }
        }
    }

    func deleteTaskDidTapped(with task: Task) {
        view?.showDeleteTask(withMessage: "\(Strings.deleteQuestion) \"\(task.title)\"?", title: "") { [weak self] in
            self?.deleteTask(task)
        }
    }

    func shareTask(_ task: Task) {
        view?.showShareTask(title: task.title, description: task.description, dateString: task.date.taskDateString())
    }
}
