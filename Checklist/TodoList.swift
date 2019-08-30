//
//  TodoList.swift
//  Checklist
//
//  Created by Diógenes Dauster on 8/16/19.
//  Copyright © 2019 Dauster. All rights reserved.
//

import Foundation

let todoDirectoryURL = URL(fileURLWithPath: "todos", relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]).appendingPathExtension("plist")

class TodoList: Codable {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriority: [ChecklistItem] = [] {
        didSet {
            saveTodoOnPlist()
        }
    }
    private var mediumPriority: [ChecklistItem] = [] {
        didSet {
            saveTodoOnPlist()
        }
    }
    private var lowPriority: [ChecklistItem] = [] {
        didSet {
            saveTodoOnPlist()
        }
    }
    
    private var noPriority: [ChecklistItem] = [] {
        didSet {
            saveTodoOnPlist()
        }
    }
    
    //var todos: [ChecklistItem]
    
    init() {
        
        if FileManager.default.fileExists(atPath: todoDirectoryURL.path) {
            loadTodoFromPlist()
        } else {
            
            let row0Item = ChecklistItem()
            let row1Item = ChecklistItem()
            let row2Item = ChecklistItem()
            let row3Item = ChecklistItem()
            let row4Item = ChecklistItem()
            let row5Item = ChecklistItem()
            let row6Item = ChecklistItem()
            let row7Item = ChecklistItem()
            let row8Item = ChecklistItem()
            let row9Item = ChecklistItem()
            
            
            row0Item.name =  "Take a Job"
            row1Item.name =  "Watch a movie"
            row2Item.name =  "Code an app"
            row3Item.name =  "Walk the dog"
            row4Item.name =  "Study design patterns"
            row5Item.name =  "Take a Nap"
            row6Item.name =  "Plan vacation"
            row7Item.name =  "Play Soccer"
            row8Item.name =  "Find a New Job"
            row9Item.name =  "Look for a girl friend"
            
            
            addTodo(row0Item, for: .medium)
            addTodo(row1Item, for: .high)
            addTodo(row2Item, for: .low)
            addTodo(row3Item, for: .no)
            addTodo(row4Item, for: .medium)
            addTodo(row5Item, for: .medium)
            addTodo(row6Item, for: .high)
            addTodo(row7Item, for: .low)
            addTodo(row8Item, for: .no)
            addTodo(row9Item, for: .medium)
            
            saveTodoOnPlist()
        }
        
    }
    
    
    init(highPriority: [ChecklistItem], mediumPriority: [ChecklistItem], lowPriority: [ChecklistItem],
         noPriority: [ChecklistItem]) {
        
        self.highPriority = highPriority
        self.mediumPriority = mediumPriority
        self.lowPriority = lowPriority
        self.noPriority = noPriority
        
    }
    
    private func loadTodoFromPlist() {
        
        do {
            
            let plistDecoder = PropertyListDecoder()
            let plistData = try Data(contentsOf: todoDirectoryURL)
            let todoList = try plistDecoder.decode(TodoList.self, from: plistData)
            
            self.highPriority = todoList.highPriority
            self.mediumPriority = todoList.mediumPriority
            self.lowPriority = todoList.lowPriority
            self.noPriority = todoList.noPriority
            
        } catch {
            print(error)
        }
        
        
    }
    
    func saveTodoOnPlist() {
        
        do {
            
            let plistEncoder = PropertyListEncoder()
            let plistData = try plistEncoder.encode(self)
            try plistData.write(to: todoDirectoryURL, options: .atomic)
            
        } catch {
            print(error)
        }
        
        
    }
    
    
    func addTodo(_ item: ChecklistItem, for priority: Priority, at index: Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highPriority.append(item)
            } else {
                highPriority.insert(item, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriority.append(item)
            } else {
                mediumPriority.insert(item, at: index)
            }
        case .low:
            if index < 0 {
                lowPriority.append(item)
            } else {
                lowPriority.insert(item, at: index)
            }
        case .no:
            if index < 0 {
                noPriority.append(item)
            } else {
                noPriority.insert(item, at: index)
                
            }
        }
    }
    
    func todoList(for priority: Priority) -> [ChecklistItem] {
        switch priority {
        case .high:
            return highPriority
        case .medium:
            return mediumPriority
        case .low:
            return lowPriority
        case .no:
            return noPriority
        }
    }
    
    func newTodo() -> ChecklistItem {
        let newTodo = ChecklistItem()
        newTodo.name = randomText()
        newTodo.checked = true
        //mediumPriority.append(newTodo)
        return newTodo
    }

    
    func move(item: ChecklistItem, from sourcePriority: Priority, at sourceIndex: Int, to destonationPriority: Priority, at destinationIndex: Int) {
        remove(item, from: sourcePriority, at: sourceIndex)
        addTodo(item, for: destonationPriority, at: destinationIndex)
    }
    
    func remove(_ item: ChecklistItem, from priority: Priority,at index: Int) {
        
        switch priority {
        case .high:
            highPriority.remove(at: index)
        case .medium:
            mediumPriority.remove(at: index)
        case .low:
            lowPriority.remove(at: index)
        case .no:
            noPriority.remove(at: index)
        }
    }
    
    
    func randomText() -> String {
        let titles = ["Fale baixo", "Tomar uma bicada", "Sonhar é gratis" ,"Carai de Asa"]
        let randomNumber = Int.random(in: 0...titles.count-1)
        return titles[randomNumber]
    }
    
}
