//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Diógenes Dauster on 8/17/19.
//  Copyright © 2019 Dauster. All rights reserved.
//

import UIKit


protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
    
    weak var delegate:ItemDetailViewControllerDelegate?
    weak var todoList: TodoList?
    weak var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        if let item = itemToEdit {
            if let textFieldText = textField.text {
                item.name = textFieldText
            }
            item.checked = false
            delegate?.itemDetailViewController(self ,didFinishEditing: item)
        } else {
            if let item = todoList?.newTodo() {
                if let textFieldText = textField.text {
                    item.name = textFieldText
                }
                item.checked = false
                delegate?.itemDetailViewController(self ,didFinishAdding: item)
            }
        }
        
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.name
            doneBarButton.isEnabled = true
        }
        
        navigationItem.largeTitleDisplayMode = .never
        textField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    
}

extension ItemDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       
        
        guard let oldText = textField.text,
        let stringRange = Range(range, in: oldText)  else {
            return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        
        return true
    }
    
}
