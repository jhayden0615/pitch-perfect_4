//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jonathan Hayden on 5/22/15.
//  Copyright (c) 2015 Jonathan Hayden. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
 
  
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button. We only want to display it when we are recording
        stopButton.hidden = true
        //Enable the record button for use
        recordButton.enabled = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        //show the message showing "recording"
        recordingInProgress.hidden = false
        
        //show the stop button for the user
        stopButton.hidden = false
        
        //disable the record button action. This will prevent the user from starting over by mistake without hitting the stop button
        recordButton.enabled = false
        
        
        //Set the directory and filename for the file to be recorded
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as! String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        
        //the file name will be date/time specific, and will be a .wav format
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate        (currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
       
        
        //Set up audio session
        var session =  AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        
        //record the audio
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //If the audio successfully finished recording
        if (flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            //Move to the second scene of the app, or perfom a segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        //If there was a problem with the recording
        else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
           
        }
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    

    //Stop the audio recording
    @IBAction func stopAudio(sender: UIButton) {
        //Hide teh "recording" label
        recordingInProgress.hidden = true
        
        //Stop the audio recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)    }
    }


