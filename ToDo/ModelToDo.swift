//
//  ViewController.swift
//  дз 1 _ ШМР
//
//  Created by Zhdan Pavlov on 11.06.2023.
//

import Foundation

struct ToDoItem {

    enum Importance: String {
        case unimportant
        case ordinary
        case important
    }

    /// ID
    let id: String

    /// Строковое поле
    let text: String

    /// Дедлайн
    let deadlineDate: Date?

    /// Флаг о выполненности задачи
    let taskDone: Bool

    /// Дата создания
    let creationDate: Date

    /// Дата изменения
    let changingDate: Date?

    /// Важность задач
    let importance: Importance

    init(
        id: String = UUID().uuidString,
        text: String,
        deadlineDate: Date?,
        taskDone: Bool,
        creationDate: Date = .now,
        changingDate: Date?,
        importance: Importance
    ) {
        self.id = id
        self.text = text
        self.deadlineDate = deadlineDate
        self.taskDone = taskDone
        self.creationDate = creationDate
        self.changingDate = changingDate
        self.importance = importance
    }
}

extension ToDoItem {
    var json: Any {
        var jsonDictionary: [String: Any] = [
            "id": id,
            "text": text,
            "taskDone": taskDone,
            "creationDate": creationDate.timeIntervalSince1970,
        ]
        if let deadlineDate {
            jsonDictionary["deadlineDate"] = deadlineDate.timeIntervalSince1970
        }
        if let changingDate {
            jsonDictionary["changingDate"] = changingDate.timeIntervalSince1970
        }
        if importance != .ordinary {
            jsonDictionary["importance"] = importance.rawValue
        }
        return jsonDictionary
    }

    /// Разбор json
    static func parse(json: Any) -> ToDoItem? {
        guard let jsonData = json as? [String: Any],
              let text = jsonData["text"] as? String,
              let id = jsonData["id"] as? String,
              let creationDate = makeDate(jsonData, "creationDate") else {
            return nil
        }
        let deadlineDate = makeDate(jsonData, "deadlineDate")
        let changingDate = makeDate(jsonData, "changingDate")
        
        let taskDone = jsonData["taskDone"] as? Bool ?? false

        let importance: Importance
        if let importanceRawValue = jsonData["importance"] as? String {
            importance = Importance(rawValue: importanceRawValue) ?? .ordinary
        } else {
            importance = .ordinary
        }

        return ToDoItem(
            id: id,
            text: text,
            deadlineDate: deadlineDate,
            taskDone: taskDone,
            creationDate: creationDate,
            changingDate: changingDate,
            importance: importance
        )
    }

    private static func makeDate(_ dictionary: [String: Any], _ key: String) -> Date? {
        guard let timeInterval = dictionary[key] as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
}
