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
    var tableData: [[ChecklistItem?]?]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
        let sectionTitleCount = UILocalizedIndexedCollation.current().sectionTitles.count
        var allSections = [[ChecklistItem?]?](repeating: nil, count: sectionTitleCount)
        var sectionNumber = 0
        let collation = UILocalizedIndexedCollation.current()
        for item in todoList.todos{
            sectionNumber = collation.section(for: item, collationStringSelector: #selector(getter: ChecklistItem.text))
            if allSections[sectionNumber] == nil {
                allSections[sectionNumber] = [ChecklistItem?]()
            }
            allSections[sectionNumber]!.append(item)
        }
        tableData = allSections
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
        
        todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section] == nil ? 0 : tableData[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for:  indexPath)
        //let item = todoList.todos[indexPath.row]
        
        if let item = tableData[indexPath.section]?[indexPath.row] {
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UILocalizedIndexedCollation.current().sectionTitles[section]
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
            var items = [ChecklistItem]()
            for indexpath in selectedItems {
                items.append(todoList.todos[indexpath.row])
            }
            todoList.remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedItems, with: .automatic)
            tableView.endUpdates()
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
            if let addItemViewController = segue.destination as? ItemDetailViewController  {
                addItemViewController.delegate = self
                addItemViewController.todoList = todoList
            }
        }else if segue.identifier == "EditItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController{
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


extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        
        let rowIndex = todoList.todos.count - 1
        let indexPaths = IndexPath(row: rowIndex, section: 0)
        tableView.insertRows(at: [indexPaths], with: .automatic)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = todoList.todos.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configurateTextItem(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
