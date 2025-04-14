//
//  Task.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import Foundation

struct Task {
    let title: String
    let description: String
    let dateString: String
    let isDone: Bool
}

extension Task {
    static func makeMockData() -> [Task] {
        let mockArray = [
            Task(
                title: "Почитать книгу",
                description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                dateString: "09/10/24",
                isDone: true
            ),
            Task(
                title: "Уборка в квартире",
                description: "Провести генеральную уборку в квартире",
                dateString: "02/10/24",
                isDone: false
            ),
            Task(
                title: "Заняться спортом",
                description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!",
                dateString: "02/10/24",
                isDone: false
            ),
            Task(
                title: "Работа над проектом",
                description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач",
                dateString: "09/10/24",
                isDone: true
            ),
            Task(
                title: "Вечерний отдых",
                description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку",
                dateString: "02/10/24",
                isDone: false
            )
        ]

        return mockArray
    }
}
