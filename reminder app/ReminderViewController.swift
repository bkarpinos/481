//
//  ReminderViewController.swift
//  reminder app
//
//  Created by Brett Karpinos on 10/9/16.
//
//

import UIKit

class ReminderViewController: UIViewController, UITextFieldDelegate {
    
    

    
    //MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    
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
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as AnyObject? === saveButton {
            let name = nameTextField.text ?? ""
            let date = dateTextField.text ?? ""
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            reminder = Reminder(name: name, date: date)

        }
    }
    
    
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: AnyObject) {
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidReminderName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

