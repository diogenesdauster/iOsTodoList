//
//  ViewController.swift
//  TodoList
//
//  Created by Diogenes Dauster on 2/19/19.
//  Copyright © 2019 Diogenes Dauster. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList: TodoList

    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todoList.todoList(for: priority).count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for:  indexPath)
        //let item = todoList.todos[indexPath.row]
        if let priority = priorityForSectionIndex(indexPath.section){
            let items = todoList.todoList(for: priority)
            let item = items[indexPath.row]
            configurateTextItem(for: cell, with: item)
            configurateCheckItem(for: cell, with: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = priorityForSectionIndex(indexPath.section) {
                let items = todoList.todoList(for: priority)
                let item = items[indexPath.row]
                item.toogle()
                configurateCheckItem(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let priority = priorityForSectionIndex(indexPath.section){
            let item = todoList.todoList(for: priority)[indexPath.row]
            todoList.remove(item, from: priority, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        if let priority = priorityForSectionIndex(section){
            switch priority {
            case .high:
                title = "High Priority Todos"
            case .medium:
                title = "Medium Priority Todos"
            case .low:
                title = "Low Priority Todos"
            case .no:
                title = "No Priority Todos"

            }
        }
        return title
    }
    
    func configurateTextItem(for cell: UITableViewCell, with item: ChecklistItem ){
        if let checkmark = cell as? CheckmarkTableViewCell {
            checkmark.labelText.text = item.text
        }
    }
    
    func configurateCheckItem(for cell:UITableViewCell, with item: ChecklistItem){
        
        guard let checkmark  = cell as? CheckmarkTableViewCell else {
            return
        }
        
        if item.checked  {
            checkmark.checkmark.text = "√"
        }else{
            checkmark.checkmark.text = ""
        }
        
    }
    
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedItems = tableView.indexPathsForSelectedRows {
            for indexpath in selectedItems {
                if let priority = priorityForSectionIndex(indexpath.section) {
                    let todos = todoList.todoList(for: priority)
                    let index = indexpath.row > todos.count - 1 ? todos.count - 1 : indexpath.row
                    let item = todos[index]
                    todoList.remove(item, from: priority, at: index)
                    
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedItems, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
    @IBAction func addTodo(_ sender: Any){
        let newRowIndex = todoList.todoList(for: .medium).count
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: TodoList.Priority.medium.rawValue)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController  {
                addItemViewController.delegate = self
                addItemViewController.todoList = todoList
            }
        }else if segue.identifier == "EditItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController{
               if let cell = sender as? UITableViewCell,
                  let indexPath = tableView.indexPath(for: cell) ,
                  let priority = priorityForSectionIndex(indexPath.section){
                    let item = todoList.todoList(for: priority)[indexPath.row]
                    addItemViewController.itemToEdit = item
                    addItemViewController.delegate = self
              }
            }
        }
    }
}


extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        
        let rowIndex = todoList.todoList(for: .medium).count - 1
        let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        for priority in TodoList.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.index(of: item){
                let indexPath = IndexPath(item: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath){
                    configurateTextItem(for: cell, with: item)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
