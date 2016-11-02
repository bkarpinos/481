//
//  Reminder.swift
//  reminder app
//
//  Created by Brett Karpinos on 10/19/16.
//
//

import UIKit
import Foundation

class Reminder: NSObject, NSCoding{
    //MARK: Properties
    
    var name : String
    var date : Date
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reminders")
    
    
    //MARK: Types
    struct PropertyKey {
        static let nameKey = "name"
        static let dateKey = "date"
    }
    
    // MARK: Initialization
    
    init?(name: String, date: Date) {
        // Initialize stored properties.
        self.name = name
        self.date = date
        
        super.init()
        
        if name.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(date, forKey: PropertyKey.dateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as? Date
        self.init(name: name, date: date!)
    }
}
