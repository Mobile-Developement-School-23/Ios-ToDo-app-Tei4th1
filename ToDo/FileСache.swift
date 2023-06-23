//
//  FileСache.swift
//  ToDo
//
//  Created by Zhdan Pavlov on 23.06.2023.
//

import Foundation

final class FileCache {
    
    private var idToItem: [String: ToDoItem] = [:]
    
    var items: [ToDoItem] {
        //return Array(idToItem.values)
        return [ToDoItem(text: "zhopa", deadlineDate: nil, taskDone: false, changingDate: .now, importance: .important)]
    }

    
    /// Сохранение всех дел в файл
    func write(fileName: String) {
        var dictionaries = [[String: Any]]()
        idToItem.values.forEach { item in
            if let dictrianoryItem = item.json as? [String: Any] {
                dictionaries.append(dictrianoryItem)
            }
        }
        let jsonDictionaries = try? JSONSerialization.data(withJSONObject: dictionaries,options: .prettyPrinted)
        try? jsonDictionaries?.write(to: getDocumentsDirectory().appendingPathComponent("\(fileName).json"))
    }
    
    /// Загрузка всех дел из файла
    func read(fileName: String) {
        guard let data = try? Data(contentsOf: getDocumentsDirectory().appendingPathComponent("\(fileName).json")),
              let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
        
        jsonArray.forEach { dictionary in
            if let todoItem = ToDoItem.parse(json: dictionary) {
                addItem(item: todoItem)
            }
        }
    }
    
    /// Поиск document directory
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

extension FileCache {
    
    func addItem(item: ToDoItem) {
        idToItem[item.id] = item
    }

    func removeItem(id: String) {
        idToItem[id] = nil
    }
}
