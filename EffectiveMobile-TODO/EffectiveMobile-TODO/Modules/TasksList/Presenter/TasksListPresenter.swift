//
//  TasksListPresenter.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

// MARK: - Protocols

protocol TasksListViewInput: AnyObject {
    func setupFooter(with text: String)
}

protocol TasksListViewOutput: AnyObject {
    func didLoadView()
    func findTasks(with text: String)
    func addNewTask()
}

protocol TasksListTableViewInput: AnyObject {
    func refreshData()
}

protocol TasksListTableViewOutput: AnyObject {
    var findedModels: [Task]? { get set }

    func taskDidTapped(withIndex index: Int)
}

// MARK: - TasksListPresenter

final class TasksListPresenter {

    // MARK: - Internal Properties

    var findedModels: [Task]? = nil {
        didSet {
            tableView?.refreshData()
            configureFooter()
        }
    }

    weak var view: TasksListViewInput?
    weak var tableView: TasksListTableViewInput?
    var router: TasksListRouterProtocol
    var interactor: TasksListInteractorProtocol

    // MARK: - Private Properties

    var contentModel: [Task]? = nil {
        didSet {
            findedModels = contentModel
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
    func setupContentModel() {
        contentModel = interactor.obtainTasksFromDataBase()
    }

    func configureFooter() {
        guard let findedModels else {
            view?.setupFooter(with: "0 Задач")
            return
        }

        let countText = getCountText(from: findedModels.count)

        let footerText = "\(findedModels.count) \(countText)"

        searchText.isEmpty
            ? view?.setupFooter(with: footerText)
            : view?.setupFooter(with: "Найдено \(footerText)")
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
}

// MARK: - TasksListViewInput

extension TasksListPresenter: TasksListViewOutput {
    func didLoadView() {
        setupContentModel()
    }

    func findTasks(with text: String) {
        searchText = text

        guard !text.isEmpty else {
            findedModels = contentModel
            return
        }

        findedModels = []

        contentModel?.forEach { task in
            guard
                task.title.lowercased().contains(text.lowercased()) || task.description.lowercased().contains(text.lowercased())
            else { return }

            findedModels?.append(task)
        }
    }

    func addNewTask() {
        router.toDetailTask?(nil)
    }
}

// MARK: - TasksListTableViewInput

extension TasksListPresenter: TasksListTableViewOutput {
    func taskDidTapped(withIndex index: Int) {
        if let contentModel, contentModel.count > index {
            router.toDetailTask?(contentModel[index])
        }
    }
}
