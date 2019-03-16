//
//  TodoList.swift
//  TodoList
//
//  Created by Diogenes Dauster on 2/26/19.
//  Copyright © 2019 Diogenes Dauster. All rights reserved.
//

import Foundation

class TodoList {
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    
    private var highPriorityTodos:[ChecklistItem] = []
    private var mediumPriorityTodos:[ChecklistItem] = []
    private var lowPriorityTodos:[ChecklistItem] = []
    private var noPriorityTodos:[ChecklistItem] = []
    
    
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

        
        addTodo(row01Item,for: .medium)
        addTodo(row02Item,for: .low)
        addTodo(row03Item,for: .high)
        addTodo(row04Item,for: .no)
        addTodo(row05Item,for: .high)
    }
    
    func addTodo(_ item: ChecklistItem, for priority: Priority) {
        switch priority {
        case .high:
            highPriorityTodos.append(item)
        case .medium:
            mediumPriorityTodos.append(item)
        case .low:
            lowPriorityTodos.append(item)
        case .no:
            noPriorityTodos.append(item)
        }
    }
    
    func todoList(for priority: Priority ) -> [ChecklistItem]{
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos
        }

    }
    
    func newTodo() -> ChecklistItem {
        let item = ChecklistItem()
        item.checked = true
        item.text = randomText()
        mediumPriorityTodos.append(item)
        return item
        
    }
    
    func move(item: ChecklistItem, to index: Int) {
//        guard let indexLocation = todos.firstIndex(of: item) else {
//            return
//        }
//        todos.remove(at: indexLocation)
//        todos.insert(item, at: index)
    }
    
    func remove(_ item: ChecklistItem, from priority: Priority,at index: Int){
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
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
