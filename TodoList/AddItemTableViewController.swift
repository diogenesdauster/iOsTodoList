//
//  AddItemTableViewController.swift
//  TodoList
//
//  Created by Diogenes Dauster on 3/5/19.
//  Copyright © 2019 Diogenes Dauster. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var barAddButton: UIBarButtonItem!
    @IBOutlet weak var barCancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        textfield.delegate = self
    }

    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
}

extension AddItemTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textfield.text,
        let stringRange = Range(range, in: oldText)
        else {
            return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            barAddButton.isEnabled = false
        }else{
            barAddButton.isEnabled = true
        }
        
        return true
    }
    
    
}
