//
//  ViewController.swift
//  TodoList
//
//  Created by Diogenes Dauster on 2/19/19.
//  Copyright © 2019 Diogenes Dauster. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for:  indexPath)
        
        if let label = cell.viewWithTag(1000) as? UILabel {
            switch( indexPath.row % 5){
            case 0 :
                label.text = "Take a Job"
            case 1 :
                label.text = "Watch a movie"
            case 2 :
                label.text = "Code an App"
            case 3 :
                label.text = "Walk the Dog"
            case 4 :
                label.text = "Study Design patterns"
            default:
                label.text = "Only Sleep"
            }            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}

