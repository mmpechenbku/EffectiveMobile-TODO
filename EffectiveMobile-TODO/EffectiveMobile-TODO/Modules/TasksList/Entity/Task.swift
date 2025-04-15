//
//  Task.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 13.04.2025.
//

import Foundation

struct Tasks: Codable {
    let items: [Task]

    enum CodingKeys: String, CodingKey {
        case items = "todos"
    }
}

struct Task: Codable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let isDone: Bool

    init(
        id: String,
        title: String,
        description: String,
        date: Date,
        isDone: Bool
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.isDone = isDone
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID().uuidString
        self.title = (try? container.decode(String.self, forKey: .title)) ?? Strings.task
        self.date = (try? container.decode(Date.self, forKey: .date)) ?? Date()
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.isDone = (try? container.decode(Bool.self, forKey: .isDone)) ?? false
    }

    enum CodingKeys: String, CodingKey {
        case id, title, date
        case description = "todo"
        case isDone = "completed"
    }
}

extension Task {
    static func makeMockData() -> [Task] {
        let mockArray = [
            Task(
                id: UUID().uuidString,
                title: "Почитать книгу",
                description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                date: "09/10/24".toTaskDate() ?? Date(),
                isDone: true
            ),
            Task(
                id: UUID().uuidString,
                title: "Уборка в квартире",
                description: "Провести генеральную уборку в квартире",
                date: "02/10/24".toTaskDate() ?? Date(),
                isDone: false
            ),
            Task(
                id: UUID().uuidString,
                title: "Заняться спортом",
                description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!",
                date: "02/10/24".toTaskDate() ?? Date(),
                isDone: false
            ),
            Task(
                id: UUID().uuidString,
                title: "Работа над проектом",
                description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач",
                date: "09/10/24".toTaskDate() ?? Date(),
                isDone: true
            ),
            Task(
                id: UUID().uuidString,
                title: "Вечерний отдых",
                description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку",
                date: "02/10/24".toTaskDate() ?? Date(),
                isDone: false
            )
        ]

        return mockArray
    }
}
