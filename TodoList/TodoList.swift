//
//  TodoList.swift
//  TodoList
//
//  Created by Diogenes Dauster on 2/26/19.
//  Copyright © 2019 Diogenes Dauster. All rights reserved.
//

import Foundation

class TodoList {
    var todos: [ChecklistItem]
    
    init(){
        let row01Item = ChecklistItem()
        let row02Item = ChecklistItem()
        let row03Item = ChecklistItem()
        let row04Item = ChecklistItem()
        let row05Item = ChecklistItem()
        
        row01Item.text = "Take a Job"
        row02Item.text = "Watch a movie"
        row03Item.text = "Code an App"
        row04Item.text = "Walk the Dog"
        row05Item.text = "Study Design patterns"

        todos = []
        
        todos.append(row01Item)
        todos.append(row02Item)
        todos.append(row03Item)
        todos.append(row04Item)
        todos.append(row05Item)
    }
    
    func newTodo() -> ChecklistItem {
        let item = ChecklistItem()
        item.checked = true
        item.text = randomText()
        todos.append(item)
        return item
        
    }
    
    func move(item: ChecklistItem, to index: Int) {
        guard let indexLocation = todos.firstIndex(of: item) else {
            return
        }
        todos.remove(at: indexLocation)
        todos.insert(item, at: index)
    }
    
    func remove(items: [ChecklistItem]){
        for item in items {
            if let index = todos.index(of: item){
                todos.remove(at: index)
            }
        }
    }
    
    private func randomText() -> String {
        var titles = ["New todo item",
                      "Generic todo",
                      "Fill me out",
                      "I need something to do",
                      "Much todo about nothing"]
        let randomNumber = Int.random(in: 0 ... titles.count-1 )
        return titles[randomNumber]
    }
}
