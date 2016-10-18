//
//  TaskList.swift
//  ReminderApp
//
//  Created by Elizabeth Gentile on 10/18/16.
//  Copyright (c) 2016 Elizabeth Gentile. All rights reserved.
//

import UIKit

class TaskList: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
