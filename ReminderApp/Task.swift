//
//  Meal.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/26/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit

class Task {
    // MARK: Properties
    
    var title: String
    var date: String
    var description: String
    
    // MARK: Initialization
    
    init?(title: String, date: String, description: String) {
        // Initialize stored properties.
        self.title = title
        self.date = date
        self.description = description
        
        // Initialization should fail if there is no name or if the rating is negative.
        if title.isEmpty{
            return nil
        }
    }
    
}