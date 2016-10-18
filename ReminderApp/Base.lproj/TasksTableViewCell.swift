//
//  TasksTableViewCell.swift
//  ReminderApp
//
//  Created by Elizabeth Gentile on 10/11/16.
//  Copyright (c) 2016 Elizabeth Gentile. All rights reserved.
//

import UIKit


class TasksTableViewCell : UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //working on function to get data from new reminder controller
    //to this controller to add elements within the table
    /*override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            var svc = segue!.destinationViewController as secondViewController;
            
            svc.toPass = textField.text
        }
    }*/
}
