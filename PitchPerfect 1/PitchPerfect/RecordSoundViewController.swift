//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Nourah on 01/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecord : AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear started")
    }


    @IBAction func recordAudio(_ sender: Any) {
        recordLabel.text="Recording in progresss"
        stopRecordingButton.isEnabled=true
        recordButton.isEnabled=false
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath ?? "")
        
        //let session = AVAudioSession.sharedInstance()
       // try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
    
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        
        try! audioRecord = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecord.delegate = self
        audioRecord.isMeteringEnabled = true
        audioRecord.prepareToRecord()
        audioRecord.record()
    }
    @IBAction func stopRecording(_ sender: Any) {
        recordLabel.text="Stop Recording button was pressed"
        stopRecordingButton.isEnabled=false
        recordButton.isEnabled=true
        audioRecord.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "StopRecording", sender: audioRecord.url)
        } else {
            print("recording was not successfully ")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="StopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

