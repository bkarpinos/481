//
//  ReminderViewController.swift
//  reminder app
//
//  Created by Brett Karpinos on 10/9/16.
//
//

import UIKit
import Foundation
import Speech

class ReminderViewController: UIViewController, UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    

    
    //MARK: Properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @IBOutlet var recordButton: UIButton!
    private let audioEngine = AVAudioEngine()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let today = Date()
    let calen = Calendar.current
    let df = DateFormatter()
    var dc = DateComponents()
    
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
            let dateIn = dateTextField.text ?? ""
            
            let curYear = calen.component(.year, from: today)
            let curMonth = calen.component(.month, from: today)
            let curDay = calen.component(.day, from:today)
            
            dc.year = curYear
            dc.month = curMonth
            dc.day = curDay
            dc.hour = 10
            dc.minute = 3
            
            df.dateFormat = "hh:mm a MMMM dd, yyyy"
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            reminder = Reminder(name: name, date: df.date(from: dateIn)!)
            //create the local notification
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.scheduleNotification(at: df.date(from: dateIn)!, title:name/*, body:*/)
        }
    }
    
  
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: AnyObject) {
        
    }
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //let curYear = calen.component(.year, from: today)

        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        
        
        recordButton.isEnabled = false

        // Set up views if editing an existing Meal.
        if let reminder = reminder
        {
            df.dateFormat = "hh:mm a MMMM dd, yyyy"
            
            navigationItem.title = reminder.name
            nameTextField.text   = reminder.name
            dateTextField.text = df.string(from: reminder.date)
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidReminderName()
    }
    
    override public func viewDidAppear(_ animated: Bool)
    {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization
            { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation
                {
                switch authStatus
                {
                case .authorized:
                    print("Authorized");
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    print("Denied");
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    print("Restricted");
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    print("Not Determined");
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.nameTextField.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        nameTextField.text = "(Go ahead, I'm listening)"
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool)
    {
        if available
        {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        }
        else
        {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    @IBAction func recordButtonTapped()
    {
        if audioEngine.isRunning
        {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        }
        else
        {
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

