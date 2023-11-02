//
//  TasksListModel.swift
//  ToDoListWithRealmBD
//
//  Created by Alexandr Filovets on 2.11.23.
//

import UIKit
import RealmSwift

class TasksList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
}
