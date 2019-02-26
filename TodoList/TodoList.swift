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
}
