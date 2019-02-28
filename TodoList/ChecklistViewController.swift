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
            
            configurateCheckItem(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func configurateTextItem(for cell: UITableViewCell, with item: ChecklistItem ){
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.text
        }
    }
    
    func configurateCheckItem(for cell:UITableViewCell, with item: ChecklistItem){
        
        if item.checked  {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        item.toogle()
    
    }
    
    
    @IBAction func addTodo(){
        let alert = UIAlertController(title: "New Todo", message: "added item", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

