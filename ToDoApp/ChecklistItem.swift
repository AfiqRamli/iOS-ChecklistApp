//
//  ChecklistItem.swift
//  ToDoApp
//
//  Created by Afiq Ramli on 15/02/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    override init() {
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    //Loading the file saved from Systems .plist file
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    //Saving the file by decoding it through the NSKeyedArchiver
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
}
