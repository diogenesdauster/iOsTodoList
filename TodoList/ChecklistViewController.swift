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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for:  indexPath)
        let item = todoList.todos[indexPath.row]
        
        configurateTextItem(for: cell, with: item)
        configurateCheckItem(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = todoList.todos[indexPath.row]
            
            item.toogle()
            configurateCheckItem(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        todoList.todos.remove(at: indexPath.row)
        let indexPaths = IndexPath(row: indexPath.row, section: 0)
        tableView.deleteRows(at: [indexPaths], with: .automatic)
        
    }
    
    func configurateTextItem(for cell: UITableViewCell, with item: ChecklistItem ){
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
        }
    }
    
    func configurateCheckItem(for cell:UITableViewCell, with item: ChecklistItem){
        
        guard let checkmark  = cell.viewWithTag(1001) as? UILabel else {
            return
        }
        
        if item.checked  {
            checkmark.text = "√"
        }else{
            checkmark.text = ""
        }
        
    }
    
    
    
    
    @IBAction func addTodo(_ sender: Any){
        let newRowIndex = todoList.todos.count
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailV  {
                addItemViewController.delegate = self
                addItemViewController.todoList = todoList
            }
        }else if segue.identifier == "EditItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailV{
               if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                let item = todoList.todos[indexPath.row]
                addItemViewController.itemToEdit = item
                addItemViewController.delegate = self
              }
            }
        }
    }
    
}


extension ChecklistViewController: AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: ItemDetailV) {
        navigationController?.popViewController(animated: true)
    }
    
    func additemViewControllerDidFinishAddingItem(_ controller: ItemDetailV, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        
        let rowIndex = todoList.todos.count - 1
        let indexPaths = IndexPath(row: rowIndex, section: 0)
        tableView.insertRows(at: [indexPaths], with: .automatic)
    }
    
    func additemViewControllerDidFinishEditingItem(_ controller: ItemDetailV, didFinishEditing item: ChecklistItem) {
        if let index = todoList.todos.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configurateTextItem(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
