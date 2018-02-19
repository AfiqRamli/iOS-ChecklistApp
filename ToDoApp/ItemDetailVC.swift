//
//  AddItemVC.swift
//  ToDoApp
//
//  Created by Afiq Ramli on 15/02/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import UIKit

protocol ItemDetailVCDelegate: class {
    func itemDetailVCDelegateDidCancel(_ controller: ItemDetailVC)
    func itemDetailVC(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem)
    func itemDetailVC(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem)
}

class ItemDetailVC: UITableViewController {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    var itemToEdit: ChecklistItem?
    weak var delegate: ItemDetailVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure check for editing existing item
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK: Actions
    @IBAction func done() {
        guard let text = textField.text, !text.isEmpty else {
            displayAlert(withMessageOf: "Item section is empty")
            return
        }
        
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailVC(self, didFinishEditing: item)
            
        } else {
            let item = ChecklistItem()
            item.text = text
            item.checked = false
            
            delegate?.itemDetailVC(self, didFinishAdding: item)
        }
    }
    
    @IBAction func cancel() {
        // this pass the implementation to the object of delegation ie, checklistVC
        delegate?.itemDetailVCDelegateDidCancel(self)
    }
    
    //MARK: Private functions
    
    func displayAlert(withMessageOf message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}
