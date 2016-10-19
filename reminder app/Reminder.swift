//
//  Reminder.swift
//  reminder app
//
//  Created by Brett Karpinos on 10/19/16.
//
//

import UIKit

class Reminder{
    //MARK: Properties
    
    var name : String
    var date : String
    
    // MARK: Initialization
    
    init?(name: String, date: String) {
        // Initialize stored properties.
        self.name = name
        self.date = date
        
        if name.isEmpty || date.isEmpty {
            return nil
        }
    }
}
