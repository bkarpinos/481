//
//  TaskViewController.swift
//  ReminderApp
//
//  Created by Elizabeth Gentile on 10/8/16.
//  Copyright (c) 2016 Elizabeth Gentile. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController,  UITextFieldDelegate,
          UINavigationControllerDelegate{
    var task: Task?
    var taskTitle = "New Task Title"
    var descriptionTitle = "Description of task"
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
    @IBOutlet weak var taskTitleInput: UITextField!
    @IBOutlet weak var taskDescriptionInput: UITextView!
    @IBOutlet weak var reminderTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
  
    override func viewDidLoad(){
        super.viewDidLoad()
        //taskDescriptionInput.hidden = true
    }
    
    //when submit is clicked taskTitle will hold the 
    //user inputted title
    @IBAction func createTaskTitle(sender: UIButton) {
        taskTitle = taskTitleInput.text!
        reminderTitle.text = "Creating " + taskTitleInput.text! + " reminder!"
    }
    
    @IBAction func createTaskDescription(sender: UIButton) {
        descriptionTitle = taskDescriptionInput.text
    }
    @IBOutlet weak var taskDueDate: UIDatePicker!
  
    @IBAction func taskDateAction(sender: AnyObject) {
      let formatter = NSDateFormatter()
      formatter.timeStyle = .ShortStyle
      self.dateLabel.text = formatter.stringFromDate(taskDueDate.date)
    }
  // Mark: Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if saveButton === sender {
        let title = taskTitleInput.text
        let date = dateLabel.text
        let description = taskDescriptionInput.text
      
        task = Task(title: title, description: description, date: date)
    }
  }
  
}

