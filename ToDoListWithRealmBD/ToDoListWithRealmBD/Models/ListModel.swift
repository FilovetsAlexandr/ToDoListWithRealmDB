//
//  ListModel.swift
//  ToDoListWithRealmBD
//
//  Created by Alexandr Filovets on 2.11.23.
//

import UIKit
import RealmSwift

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
