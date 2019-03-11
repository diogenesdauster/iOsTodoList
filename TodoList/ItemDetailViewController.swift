//
//  AddItemTableViewController.swift
//  TodoList
//
//  Created by Diogenes Dauster on 3/5/19.
//  Copyright © 2019 Diogenes Dauster. All rights reserved.
//

import UIKit


protocol ItemDetailViewControllerDelegate: class {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func ItemDetailViewController(_ controller: ItemDetailViewController,
                                                  didFinishAdding item: ChecklistItem)
    func ItemDetailViewController(_ controller: ItemDetailViewController,
                                                  didFinishEditing item: ChecklistItem)

}

class ItemDetailViewController: UITableViewController {
    
    weak var delegate: ItemDetailViewControllerDelegate?
    weak var todoList: TodoList?
    weak var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var barAddButton: UIBarButtonItem!
    @IBOutlet weak var barCancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            textfield.text = item.text
            barAddButton.isEnabled = true
        }
        navigationItem.largeTitleDisplayMode = .never
        textfield.delegate = self
    }

    @IBAction func cancel(_ sender: Any) {
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    
    
    @IBAction func done(_ sender: Any) {
        
        if let item = itemToEdit, let text = textfield.text {
            item.text = text
            delegate?.ItemDetailViewController(self, didFinishEditing: item)
        } else {
          if let item = todoList?.newTodo(){
            if let textFieldText = textfield.text{
                item.text = textFieldText
            }
            item.checked = false
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
          }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        textfield.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
}

extension ItemDetailViewController: UITextFieldDelegate {
    
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
