//
//  ViewController.swift
//  ReminderApp
//
//  Created by Elizabeth Gentile on 10/8/16.
//  Copyright (c) 2016 Elizabeth Gentile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: properties
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self;
    }
    
    // MARK: actions

}

