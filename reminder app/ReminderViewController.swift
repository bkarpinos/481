//
//  ReminderViewController.swift
//  reminder app
//
//  Created by Brett Karpinos on 10/9/16.
//
//

import UIKit
import Foundation

class ReminderViewController: UIViewController, UITextFieldDelegate {
    
    

    
    //MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let today = Date()
    let calen = Calendar.current
    let df = DateFormatter()
    
    /*
     This value is either passed by `ReminderTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var reminder: Reminder?
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        checkValidReminderName()
    }
    
    func checkValidReminderName() {
        // Disable the Save button if the text field is empty.
        let nameText = nameTextField.text ?? ""
        saveButton.isEnabled = (!nameText.isEmpty)
        
    }


    
    //MARK: Navigation
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddReminderMode = presentingViewController is UINavigationController
        
        if isPresentingInAddReminderMode {
            dismiss(animated: true, completion: nil)
        }
        else{
            navigationController!.popViewController(animated: true)
        }
        
    }
    
    
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as AnyObject? === saveButton {
            let name = nameTextField.text ?? ""
            let date = dateTextField.text ?? ""
            
            let curYear = calen.component(.year, from: today)
            let curMonth = calen.component(.month, from: today)
            let curDay = calen.component(.day, from:today)
            
            df.dateFormat = "MMM-dd"
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            reminder = Reminder(name: name, date: df.date(from: date)!)

        }
    }
    
    
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: AnyObject) {
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let curYear = calen.component(.year, from: today)
        let curMonth = calen.component(.month, from: today)
        let curDay = calen.component(.day, from:today)

        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        
        var out: String
        // Set up views if editing an existing Meal.
        if let reminder = reminder {
            //Only display the year if it differs from todays
            if(curYear == calen.component(.year, from: reminder.date)) {
                df.dateFormat = "MMM dd"
                out = df.string(from: reminder.date)
            }
            else {
                df.dateFormat = "MMM dd yyyy"
                out = df.string(from: reminder.date)
            }
            
            navigationItem.title = reminder.name
            nameTextField.text   = reminder.name
            dateTextField.text = out
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidReminderName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

