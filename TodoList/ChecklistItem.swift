//
//  ChecklistItem.swift
//  TodoList
//
//  Created by Diogenes Dauster on 2/26/19.
//  Copyright © 2019 Diogenes Dauster. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject {
   @objc var text = ""
    var checked = false
    
    func toogle(){
        checked = !checked
    }
    


    
}
