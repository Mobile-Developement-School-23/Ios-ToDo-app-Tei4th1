//
//  ViewController.swift
//  дз 1 _ ШМР
//
//  Created by Zhdan Pavlov on 11.06.2023.
//

import UIKit

/// Элемент ToDo листа
/// Элемент ToDo листа
struct ToDoItem {

    enum Importance: String {
        case unimportant
        case ordinary
        case important
    }

    /// Уникальный ID
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


/// Расширение для структуры TodoItem
extension ToDoItem {
    
    /// Вычислимое свойство для формирования json
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
        let parseJson = try? JSONSerialization.data(
            withJSONObject: jsonDictionary,
            options: .prettyPrinted
        )
        return parseJson ?? Data()
    }

    /// Функция для разбора json
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
    
    private(set) var items: [ToDoItem] = []
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func write(fileName: String) {
        items.forEach { item in
            let jsonData = item.json as? Data
            try? jsonData?.write(to: getDocumentsDirectory().appendingPathComponent("\(String())"+".json"))
        }
    }

    func read(fileName: String) {
        guard let data = try? String(contentsOfFile: getDocumentsDirectory().appendingPathComponent("\(String())"+".json").absoluteString ) else { return }
        let item = ToDoItem.parse(json: data)!
        items.append(item)
    }

    func save(fileName: String, key: String) {
        read(fileName: fileName)
        
        let id = fileName["id"]
        let deadlineDate = (fileName, "deadlineDate")
        let changingDate = (fileName, "changingDate")
        let creationDate = (fileName, "creationDate")


        let importance: ToDoItem.Importance
        if let importanceRawValue = fileName["importance"] {
            importance = ToDoItem.Importance(rawValue: importanceRawValue) ?? .ordinary
        } else {
            importance = .ordinary
        }
            
    }
    func removeItem(fileName: String, key: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let jsonData = try? Data(contentsOf: fileURL)
            guard var jsonDictianory = try? JSONSerialization.jsonObject(with: jsonData!) as? [String: Any] else {
                return
            }
            if var texts = jsonDictianory["text"] as? [[String: Any]] {
                texts.removeAll{ ($0["id"] as? String) == UUID().uuidString }
                jsonDictianory["texts"] = texts
            }
            let updateData = try? JSONSerialization.data(withJSONObject: jsonDictianory)
            write(fileName: fileName)
        }
        
    }
    func saveAllInJson() {
        
    }
    func loadInJson(){
        
    }
    
}

