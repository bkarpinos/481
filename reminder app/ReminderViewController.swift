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
import AVFoundation

class ReminderViewController: UIViewController, UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    
    
    
    //MARK: Properties

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @IBOutlet var recordButton: UIButton!
    private var audioEngine = AVAudioEngine()
    @IBOutlet weak var mic_button: UIButton!
    
    
    //private let audioEngine = AVAudioRecorder()
    //@IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    let today = Date()
    let calen = Calendar.current
    let df = DateFormatter()
    var dc = DateComponents()
    
    //let synth = AVSpeechSynthesizer()
    
    /*
     This value is either passed by `ReminderTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new reminder.
     */
    
    var reminder: Reminder?
    

    func checkValidReminderName() {
        // Disable the Save button if the text field is empty.
        let nameText = titleLabel.text ?? ""
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
            //let name = nameTextField.text ?? ""
            let name = titleLabel.text ?? ""
            //let dateIn = dateTextField.text ?? ""
            let dateIn = dateLabel.text ?? ""
            
            
            //self.checkDate()
            
            let types: NSTextCheckingResult.CheckingType = [.date]
            let detector = try? NSDataDetector(types: types.rawValue)
            let matches = detector?.matches(in: dateIn, options: [], range: NSMakeRange(0, (dateIn as NSString).length))
            for match in matches! {
                //print(match.date ?? "no_date")
                reminder = Reminder(name: name, date: match.date!)
                
                
            }
            
            df.dateFormat = "hh:mm a MMMM dd, yyyy"
            
        }
    }//END prepare
    
    
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: AnyObject) {}
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        saveButton.isEnabled = false;
        mic_button.isAccessibilityElement = true
        mic_button.accessibilityTraits = UIAccessibilityTraitPlaysSound

        
        //let curYear = calen.component(.year, from: today)
        
        // Do any additional setup after loading the view, typically from a nib.
        //nameTextField.delegate = self
    
        
        
        recordButton.isEnabled = false
        recordButton.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction
        
        if let reminder = reminder
        {
            df.dateFormat = "hh:mm a MMMM dd, yyyy"
            
            navigationItem.title = reminder.name
            //nameTextField.text   = reminder.name
            //dateTextField.text = df.string(from: reminder.date)

            titleLabel.text = reminder.name
            dateLabel.text = df.string(from: reminder.date)
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        //checkValidReminderName()
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
    
    private func checkDate() -> Bool{
        let types: NSTextCheckingResult.CheckingType = [.date]
        let detector = try? NSDataDetector(types: types.rawValue)
        let matches = detector?.matches(in: self.dateLabel.text!, options: [], range: NSMakeRange(0, (self.dateLabel.text! as NSString).length))
        var date: Date?
        print(matches?.count ?? "SHUT UP!")
        for match in matches! {
            //print(match.date ?? "no_date")
            date = match.date
        }
        if(date == nil){
            //Give explanation that date was "bad"
            print("date is nil")
            return true
            
        }
        else if(date! < Date()) {
            //Say that date has already passed
            print("date is past")
            return true
            
        }
        
        return false
    }
    
    

    private func speakToMe(input : String, wait : Int){
        
        let synth = AVSpeechSynthesizer()
        var myUtterance = AVSpeechUtterance(string: "")
        
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        myUtterance.volume = 1
        myUtterance.rate = 0.3
        
        print("Wait Time: ",TimeInterval(wait));
        myUtterance = AVSpeechUtterance(string: input)
        synth.speak(myUtterance)
    }
    
    
    private func startRecording() throws {
        
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000), execute: {
//            print("continue")
//        })


        
        //DELAY THE CODE
        
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        
        
        try audioSession.setActive(false)
        speakToMe(input: "Say your reminder title.", wait: 3000)
        try audioSession.setActive(true)
        
        
        sleep(2)
        
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
                //self.nameTextField.text = result.bestTranscription.formattedString
                self.titleLabel.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Press to stop listening for date", for: [])
                
                //call function to listen for date
                try! self.startRecordingDate()
                
                //self.audioEngine.reset()
                

            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        //nameTextField.text = "(Go ahead, I'm listening)"
        
        titleLabel.text = "(Go ahead, I'm listening)"
        
        //try audioSession.setActive(false)
        
    }
    
    private func startRecordingDate() throws
    {
        
        //DELAY THE CODE
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)

        
        speakToMe(input: "Say the date of your reminder.", wait: 1500)
        
        sleep(2)
        
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
                //self.dateTextField.text = result.bestTranscription.formattedString
                self.dateLabel.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("Setting Date Label")
            }
            
            
            if error != nil || isFinal
            {
                self.audioEngine.stop()
                
                
                
                if (self.checkDate() == true)
                {
                    //try audioSession.setActive(false)
                    //self.mic_button.sendActions(for: .touchUpInside);
                    inputNode.removeTap(onBus: 0);
                    self.recordButton.setTitle("Please record new title name", for: [])

                    /*
                     self.recognitionRequest = nil
                     self.recognitionTask = nil
                     self.recordButton.setTitle("Please record new title name", for: [])
                     let playback = "Try to record your new title"
                     self.speakToMe(input : playback, wait: 2500)
                    */

                    self.dateLabel.text = ""
                    try! self.startRecordingDate()
                }
                else
                {
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.recordButton.isEnabled = true
                    self.recordButton.setTitle("Press Save To Create New Reminder", for: [])
                    //self.readBackReminder()
                    let playback = "Your reminder for " + self.titleLabel.text! + " is set on the date " + self.dateLabel.text! + "..... Press save to save your reminder. "
                    self.speakToMe(input : playback, wait: 2000)
                    self.saveButton.isEnabled = true;
                }
            }
            
        }
        try audioSession.setActive(false)
        
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        //nameTextField.text = "(Go ahead, I'm listening)"
        
    }//END start Recording Date
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool)
    {
        if available
        {
            recordButton.isEnabled = true
            recordButton.setTitle("Click to stop recording date", for: [])
        }
        else
        {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    @IBAction func micButtonTapped() {
        
        if audioEngine.isRunning{
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
            // call function to record and replace date text
            //self.audioEngine.reset()
        }
            
        else{
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
            
        }

    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

