//
//  ViewController.swift
//  Checklist
//
//  Created by Diógenes Dauster on 8/16/19.
//  Copyright © 2019 Dauster. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList: TodoList
    
    
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //        let sectionTitleCount = UILocalizedIndexedCollation.current().sectionTitles.count
        //        var allSections = [[ChecklistItem?]?](repeating: nil, count: sectionTitleCount)
        //        var sectionNumber = 0
        //        let colletion = UILocalizedIndexedCollation.current()
        //        for item in todoList.todos {
        //            sectionNumber = colletion.section(for: item, collationStringSelector: #selector(getter:ChecklistItem.name))
        //            if allSections[sectionNumber] == nil {
        //                allSections[sectionNumber] = [ChecklistItem?]()
        //            }
        //            allSections[sectionNumber]!.append(item)
        //        }
        //
        //        tableData = allSections
        
    }
    
    @IBAction func deleteRows(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todos = todoList.todoList(for: priority)
                    
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item  = todos[rowToDelete]
                    todoList.remove(item, from: priority, at: rowToDelete)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
    required init?(coder: NSCoder) {
        self.todoList = TodoList()
        super.init(coder: coder)
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(tableView.isEditing, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
            let destPriority = priorityForSectionIndex(destinationIndexPath.section){
            let item = todoList.todoList(for: srcPriority)[sourceIndexPath.row]
            todoList.move(item: item, from: srcPriority, at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
            
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let priority = priorityForSectionIndex(section) {
            return todoList.todoList(for: priority).count
        }
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        if let priority = priorityForSectionIndex(indexPath.section) {
            let todos = todoList.todoList(for: priority)
            let item = todos[indexPath.row]
            
            configureName(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            
            if let priority = priorityForSectionIndex(indexPath.section){
                
                let todos = todoList.todoList(for: priority)
                let item = todos[indexPath.row]
                
                if !tableView.isEditing {
                    configureCheckmark(for: cell, with: item)
                    tableView.deselectRow(at: indexPath, animated: true)
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todoList.todoList(for: priority)[indexPath.row]
            todoList.remove(item, from: priority, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    func configureName(for cell: UITableViewCell, with item: ChecklistItem) {
        if let checklistCell = cell as? ChecklistTableViewCell {
            checklistCell.todoTextLabel.text = item.name
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell,with item: ChecklistItem) {
        
        guard let checklistCell = cell as? ChecklistTableViewCell else {
            return
        }
        
        if cell.isSelected {
            if item.checked  {
                checklistCell.checkmarkLabel.text = ""
            } else {
                checklistCell.checkmarkLabel.text = "√"
            }
            
            item.toogleChecked()
            
        } else {
            
            if item.checked  {
                checklistCell.checkmarkLabel.text = "√"
            } else {
                checklistCell.checkmarkLabel.text = ""
            }
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                addItemViewController.delegate = self
                addItemViewController.todoList = todoList
            }
        } else if segue.identifier == "EditItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let priority = priorityForSectionIndex(indexPath.section){
                    let item = todoList.todoList(for: priority)[indexPath.row]
                    addItemViewController.delegate = self
                    addItemViewController.itemToEdit = item
                }
            }
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "High Priority Todo"
            case .medium:
                title = "Medium Priority Todo"
            case .low:
                title = "Low Priority Todo"
            case .no:
                title = "No Priority Todo"
                
            }
        }
        
        return title
        
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let newTodo = todoList.todoList(for: .medium).count
        
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newTodo, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
}



extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding item: ChecklistItem) {
        controller.navigationController?.popViewController(animated: true)
        
        let newTodo = todoList.todoList(for: .medium).count - 1
        let indexPath = IndexPath(row: newTodo, section: TodoList.Priority.medium.rawValue)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        
        for priority in TodoList.Priority.allCases {
            
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureName(for: cell, with: item)
                }
            }
            
            
        }
        
        
    }
    
    
}
