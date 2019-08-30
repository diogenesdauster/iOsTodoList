//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Diógenes Dauster on 8/16/19.
//  Copyright © 2019 Dauster. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject, Codable {
    @objc var name = ""
    var checked = false
    
    
    init(name: String, checked: Bool) {
        self.name = name
        self.checked = checked
    }
    
    override init() {
    }
    
    func toogleChecked() {
        checked = !checked
    }
    
}
