//
//  ViewController.swift
//  ReminderApp
//
//  Created by Elizabeth Gentile on 10/8/16.
//  Copyright (c) 2016 Elizabeth Gentile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var taskTitle = "New Task Title"
    var descriptionTitle = "Description of task"
    
    @IBOutlet weak var taskTitleInput: UITextField!
    @IBOutlet weak var taskDescriptionInput: UITextView!
    @IBOutlet weak var reminderTitle: UILabel!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        //taskDescriptionInput.hidden = true
    }
    
    
    //when submit is clicked taskTitle will hold the 
    //user inputted title
    @IBAction func createTaskTitle(sender: UIButton) {
        taskTitle = taskTitleInput.text
        reminderTitle.text = "Creating " + taskTitleInput.text + " reminder!"
    }
    
    @IBAction func createTaskDescription(sender: UIButton) {
        descriptionTitle = taskDescriptionInput.text
    }
    @IBOutlet weak var taskDueDate: UIDatePicker!
}

