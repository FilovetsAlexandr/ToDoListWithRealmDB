//
//  UITableViewCellExt.swift
//  ToDoListWithRealmBD
//
//  Created by Alexandr Filovets on 3.11.23.
//

import UIKit

extension UITableViewCell {
    
    func configure(with tasksList: TasksList) {
        
        let notCompletedTasks = tasksList.tasks.filter("isComplete = false")
        let completedTasks = tasksList.tasks.filter("isComplete = true")

        textLabel?.text = tasksList.name

        switch (notCompletedTasks.isEmpty, completedTasks.isEmpty) {
        case (false, _):
            detailTextLabel?.text = "\(notCompletedTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .red
        case (_, false):
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            detailTextLabel?.textColor = .green
        default:
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            detailTextLabel?.textColor = .black
        }
    }
}
