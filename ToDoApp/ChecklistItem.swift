//
//  ChecklistItem.swift
//  ToDoApp
//
//  Created by Afiq Ramli on 15/02/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
}
