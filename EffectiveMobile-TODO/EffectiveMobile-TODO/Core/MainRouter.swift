//
//  MainRouter.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit

final class MainRouter: NSObject {
    
    private let window: UIWindow
    private var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    func start() {
        let tasksListModule = TasksListAssembly.assembly()

        tasksListModule.router.toDetailTask = { [weak self] task in
            self?.showDetailTask(with: task)
        }
        
        navigationController = UINavigationController(rootViewController: tasksListModule.controller)
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    func showDetailTask(with task: Task? = nil) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .designPalette.yellow
        let detailTaskModule = TaskDetailAssembly.assembly(with: task)
        detailTaskModule.router.back = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(detailTaskModule.controller, animated: true)
    }
}
