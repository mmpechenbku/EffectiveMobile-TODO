//
//  TasksListRouter.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

protocol TasksListRouterProtocol: AnyObject {
    var toDetailTask: Closure<Task?>? { get set }
}

final class TasksListRouter: TasksListRouterProtocol {
    var toDetailTask: Closure<Task?>?
}
