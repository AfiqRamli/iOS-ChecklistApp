//
//  ChecklistVC.swift
//  ToDoApp
//
//  Created by Afiq Ramli on 14/02/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import UIKit

class ChecklistVC: UITableViewController, ItemDetailVCDelegate {
    
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: AddItemVC Delegate Methods
    func itemDetailVC(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem) {
        addNewItem(with: item)
        dismiss(animated: true, completion: nil)
        saveChecklistItem()
    }
    
    func itemDetailVC(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        saveChecklistItem()
    }
    
    func itemDetailVCDelegateDidCancel(_ controller: ItemDetailVC) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            //1
            let navigationController = segue.destination as! UINavigationController
            //2 Making a reference and finding AddItemVC in the midst of navigation controller stack
            let controller = navigationController.topViewController as! ItemDetailVC
            //3 - Telling AddItemVC that the delegate is now ChecklistVC / self
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailVC
            controller.delegate = self
            // Configure the sender object which is the table's cell as the index path
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                //setting the itemToEdit in the destination VC to an object
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    //MARK: TableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            
            //Update view
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItem()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // What to commit
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItem()
    }
    
    //MARK: Private methods
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    
        let label = cell.viewWithTag(1001) as!  UILabel
        
        if item.checked {
            label.text = "✔️"
        }else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func addNewItem(with item:ChecklistItem) {
        print("Adding new item")
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func saveChecklistItem() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklistItem() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
    }
    
    
}











