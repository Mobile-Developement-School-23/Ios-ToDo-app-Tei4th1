//___FILEHEADER___

import XCTest
@testable import дз_1___ШМР

final class TodoItemTests: XCTestCase {

    func testImportant() {
        // given
        let item = ToDoItem(
            id: UUID().uuidString,
            text: "text",
            deadlineDate: nil,
            taskDone: true,
            changingDate: nil,
            importance: .important
        )

        // when
        let json = item.json
        print(String(data: json as! Data, encoding: .utf8))
        let resultItem = ToDoItem.parse(json: json)

        // then
        XCTAssertEqual(item.creationDate, resultItem?.creationDate)
    }

    func testUnimportant() {
        // given
        let item = ToDoItem(
            id: UUID().uuidString,
            text: "text",
            deadlineDate: nil,
            taskDone: true,
            changingDate: nil,
            importance: .unimportant
        )

        // when
        let json = item.json
        let resultItem = ToDoItem.parse(json: json)

        // then
        XCTAssertEqual(item, resultItem)
    }

    func testOrdinary() {
        // given
        let item = ToDoItem(
            id: UUID().uuidString,
            text: "text",
            deadlineDate: nil,
            taskDone: true,
            changingDate: nil,
            importance: .ordinary
        )

        // when
        let json = item.json
        let resultItem = ToDoItem.parse(json: json)

        // then
        XCTAssertEqual(item, resultItem)
    }

    func testWrongImportanceValue() {
        // given
        let dictionary: [String: Any] = [
            "id": "id",
            "text": "text",
            "taskDone": true,
            "importance": "hui",
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary) else {
            XCTFail()
            return
        }

        // when
        let resultItem = ToDoItem.parse(json: data)

        // then
        XCTAssertEqual(resultItem?.importance, .ordinary)
    }

    func testWithoutImportance() {
        // given
        let dictionary: [String: Any] = [
            "id": "id",
            "text": "text",
            "taskDone": true,
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary) else {
            XCTFail()
            return
        }

        // when
        let resultItem = ToDoItem.parse(json: data)

        // then
        XCTAssertEqual(resultItem?.importance, .ordinary)
    }

    func testJSONOrdinaryImportance() {
        // given
        let item = ToDoItem(
            id: UUID().uuidString,
            text: "text",
            deadlineDate: nil,
            taskDone: true,
            changingDate: nil,
            importance: .ordinary
        )

        // when
        let json = item.json
        guard let jsonData = json as? Data,
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail()
            return
        }

        // then
        XCTAssertEqual(dictionary["importance"] as? String, nil)
        
    }

    func testJSONImportantImportance() {
        // given
        let item = ToDoItem(
            id: UUID().uuidString,
            text: "text",
            deadlineDate: nil,
            taskDone: true,
            changingDate: nil,
            importance: .important
        )

        // when
        let json = item.json
        guard let jsonData = json as? Data,
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail()
            return
        }

        // then
        XCTAssertEqual(dictionary["importance"] as? String, "important")
    }
    func testPrintPath() {
        // given
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        //let fileURl = documentDirectory.appendingPathComponent("fileName.json")
       // let data = try? String(contentsOfFile: fileURl.path)
        // when
        print(data)


        // then
    }
    
}

extension ToDoItem: Equatable {
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.creationDate == rhs.creationDate
    }
}
