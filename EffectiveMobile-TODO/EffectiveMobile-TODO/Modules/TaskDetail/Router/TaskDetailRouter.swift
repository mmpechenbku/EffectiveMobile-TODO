//
//  TaskDetailRouter.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

protocol TaskDetailRouterProtocol: AnyObject {
    var back: ClosureVoid? { get set }
}

final class TaskDetailRouter: TaskDetailRouterProtocol {
    var back: ClosureVoid?
}
