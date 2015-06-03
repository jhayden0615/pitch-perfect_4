//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jonathan Hayden on 5/24/15.
//  Copyright (c) 2015 Jonathan Hayden. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSlowAudio(sender: UIButton) {
        //This function will play the recorded audio at a slow rate (half speed = 0.5)
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    @IBAction func playFastAudio(sender: UIButton) {
        //This function will play the audio at a rate of twice the normal speed
        audioPlayer.stop()
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        //This function will set the pitch to a higher than normal setting then play the audio
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        //This function will set the pitch to a lower than normal setting then play the audio
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        //This function will set the pitch to a higher than normal setting then play the audio
            audioPlayer.stop()
            audioEngine.stop()
            audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to:changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    @IBAction func stopAudio(sender: UIButton){
        //This function stops the audio playback in response to pressing the Stop Audio button
        audioPlayer.stop()
        
    }
}