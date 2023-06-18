//
//  ViewController.swift
//  дз 1 _ ШМР
//
//  Created by Zhdan Pavlov on 11.06.2023.
//

import UIKit

/// Элемент ToDo листа
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
        id: String,
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
//        let parseJson = try? JSONSerialization.data(
//            withJSONObject: jsonDictionary,
//            options: .prettyPrinted )
        return jsonDictionary
    }

    /// Разбор json
    static func parse(json: Any) -> ToDoItem? {
        guard let jsonData = json as? Data,
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
              let text = dictionary["text"] as? String else {
            return nil
        }
        let id = (dictionary["id"] as? String) ?? UUID().uuidString

        let deadlineDate = makeDate(dictionary, "deadlineDate")
        let changingDate = makeDate(dictionary, "changingDate")
        let creationDate = makeDate(dictionary, "creationDate")

        let taskDone = dictionary["taskDone"] as? Bool ?? false

        let importance: Importance
        if let importanceRawValue = dictionary["importance"] as? String {
            importance = Importance(rawValue: importanceRawValue) ?? .ordinary
        } else {
            importance = .ordinary
        }

        return ToDoItem(
            id: id,
            text: text,
            deadlineDate: deadlineDate,
            taskDone: taskDone,
            creationDate: creationDate ?? .now,
            changingDate: changingDate,
            importance: importance
        )
    }

    private static func makeDate(_ dictionary: [String: Any], _ key: String) -> Date? {
        guard let timeInterval = dictionary[key] as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
}

final class FileCache{
    
    private(set) var idToItem: [String: ToDoItem] = [:]
    /// Сохранение всех дел в файл
    func write(fileName: String) {
        var dictionaries = [[String: Any]]()
        idToItem.values.forEach { item in
            if let dictrianoryItem = item.json as? [String: Any] {
                dictionaries.append(dictrianoryItem)
            }
        }
        let jsonDictionaries = try? JSONSerialization.data(
                        withJSONObject: dictionaries,
                        options: .prettyPrinted
        )
        try? jsonDictionaries?.write(to: getDocumentsDirectory().appendingPathComponent("\(fileName).json"))
    }
    
    /// Загрузка всех дел из файла
    func read(fileName: String) {
        guard let data = try? String(contentsOfFile:                    getDocumentsDirectory().appendingPathComponent("\(fileName).json").absoluteString ),
              let item = ToDoItem.parse(json: data) else { return }
        idToItem[item.id] = item
    }
    
    /// Поиск document directory
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

extension FileCache {
    
    /// Добавление item
    func addItem(item: ToDoItem) {
        idToItem[item.id] = item
    }
    
    /// Удаления item
    func removeItem(id: String) {
        idToItem[id] = nil
    }
}


