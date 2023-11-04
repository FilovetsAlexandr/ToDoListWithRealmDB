//
//  TasksListTVC.swift
//  ToDoListWithRealmBD
//
//  Created by Alexandr Filovets on 2.11.23.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {
    
    var tasksLists: Results<TasksList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tasksLists = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        navigationItem.rightBarButtonItem = add
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(editButtonTapped))
             navigationItem.leftBarButtonItem = trashButton
    }
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        let byKeyPath = sender.selectedSegmentIndex == 0 ? "name" : "date"
        tasksLists = tasksLists.sorted(byKeyPath: byKeyPath)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tasksLists.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let taskList = tasksLists[indexPath.row]
        cell.configure(with: taskList)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskList = tasksLists[indexPath.row]
            StorageManager.deleteTasksList(tasksList: taskList)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
   
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            StorageManager.deleteTasksList(tasksList: currentList)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editContextualAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesListTasks(currentList: currentList, indexPath: indexPath)
        }
        
        let doneContextualAction = UIContextualAction(style: .destructive, title: "Done") { [weak self] _, _, _ in
            StorageManager.makeAllDone(tasksList: currentList)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        deleteContextualAction.backgroundColor = .red
        editContextualAction.backgroundColor = .gray
        doneContextualAction.backgroundColor = .green
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [doneContextualAction, editContextualAction, deleteContextualAction])
        
        return swipeActionsConfiguration
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TasksTVC,
           let indexPath = tableView.indexPathForSelectedRow {
            let currentTasksList = tasksLists[indexPath.row]
            destinationVC.currentTasksList = currentTasksList
        }
    }
    // MARK: - Actions
    
    @objc private func addBarButtonSystemItemSelector() { alertForAddAndUpdatesListTasks() }
    
    @objc func editButtonTapped() { tableView.setEditing(!tableView.isEditing, animated: true) }

    
    private func alertForAddAndUpdatesListTasks(currentList: TasksList? = nil, indexPath: IndexPath? = nil) {
        
        let title = currentList == nil ? "New list" : "Edit List"
        let messege = "Please insert list name"
        let doneButtonName = currentList == nil ? "Save" : "Update"
        
        let alertController = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { [weak self] _ in
            
            guard let self,
                  let newListName = alertTextField.text,
                  !newListName.isEmpty else { return }
            
            /// логика редактирования
            if let currentList = currentList,
               let indexPath = indexPath {
                StorageManager.editTasksList(tasksList: currentList, newListName: newListName)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                /// логика создания нового объекта
                let taskList = TasksList()
                taskList.name = newListName
                StorageManager.saveTasksList(tasksList: taskList)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.text = currentList?.name
            alertTextField.placeholder = "List name"
        }
        
        present(alertController, animated: true)
    }
}
