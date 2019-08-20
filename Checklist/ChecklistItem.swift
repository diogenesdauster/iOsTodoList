//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Diógenes Dauster on 8/16/19.
//  Copyright © 2019 Dauster. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject {
    @objc var name = ""
    var checked = false
    
    func toogleChecked() {
        checked = !checked
    }
    
}
