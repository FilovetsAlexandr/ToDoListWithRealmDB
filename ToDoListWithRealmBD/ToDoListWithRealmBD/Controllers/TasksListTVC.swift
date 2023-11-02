//
//  TasksListTVC.swift
//  ToDoListWithRealmBD
//
//  Created by Alexandr Filovets on 2.11.23.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {
    
    var taskLists: Results<TasksList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskLists = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        navigationItem.rightBarButtonItem = add
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
             navigationItem.leftBarButtonItem = editButton
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let taskList = taskLists[indexPath.row]
        cell.textLabel?.text = taskList.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskList = taskLists[indexPath.row]
            StorageManager.deleteTasksList(tasksList: taskList)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let taskList = taskLists[sourceIndexPath.row]
        StorageManager.moveTasksList(from: sourceIndexPath.row, to: destinationIndexPath.row)
        taskLists = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
    }
    
    // MARK: - Actions
    
    @objc private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesListTasks()
    }
    
    @objc func editButtonTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.leftBarButtonItem?.title = "Done"
        } else {
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }

    
    private func alertForAddAndUpdatesListTasks() {
        let title = "New list"
        let message = "Please insert list name"
        let doneButtonName = "Save"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { _ in
            guard let newListName = alertController.textFields?.first?.text else { return }
            
            let taskList = TasksList()
            taskList.name = newListName
            StorageManager.saveTasksList(tasksList: taskList)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            textField.placeholder = "List name"
        }
        
        present(alertController, animated: true)
    }
}
