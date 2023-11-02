//
//  StorageManager.swift
//  ToDoListWithRealmBD
//
//  Created by Alexandr Filovets on 2.11.23.
//

import UIKit
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func getAllTasksLists() -> Results<TasksList> {
        return realm.objects(TasksList.self).sorted(byKeyPath: "name")
    }
    
    static func deleteTasksList(tasksList: TasksList) {
        do {
            try realm.write {
                realm.delete(tasksList)
            }
        } catch {
            print("deleteTasksList error: \(error)")
        }
    }
    static func moveTasksList(from sourceIndex: Int, to destinationIndex: Int) {
        do {
            try realm.write {
                var taskLists = Array(getAllTasksLists())
                let sourceList = taskLists[sourceIndex]
                let destinationList = taskLists[destinationIndex]
                
                taskLists.remove(at: sourceIndex)
                taskLists.insert(destinationList, at: destinationIndex)
                
                // Обновляем даты всех задач в списке для сортировки
                for (index, taskList) in taskLists.enumerated() {
                    taskList.date = Date().addingTimeInterval(Double(index))
                }
            }
        } catch {
            print("moveTasksList error: \(error)")
        }
    }





    static func saveTasksList(tasksList: TasksList) {
        do {
            try realm.write {
                realm.add(tasksList)
            }
        } catch {
            print("saveTasksList error: \(error)")
        }
    }
}
