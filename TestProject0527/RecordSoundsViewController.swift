//
//  RecordSoundsViewController.swift
//  TestProject0527
//
//  Created by May on 2021/5/27.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate  /* Add Delegation */  {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLbl: UILabel! //set a label when the button was pressed, the contexts of the label changes
    @IBOutlet weak var recordbtn: UIButton!
    @IBOutlet weak var stopRecordingbtn: UIButton!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        stopRecordingbtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear was called")
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }*/
    
    @IBAction func recordAudio(_ sender: UIButton) {
        recordingLbl.text = "Recording in Progress"
        recordbtn.isEnabled = false
        stopRecordingbtn.isEnabled = true
        
        /*-------------------AVAudio Functions start-------------------*/
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self /* Add Delegation, use itsleves functions, right click the  AVAudioRecorderDelegate choose the jump to the definition*/
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
         
        /*-------------------AVAudio Functions end---------------------*/
        
    }
    
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recordingLbl.text = "Recording has stopped."
        recordbtn.isEnabled = true
        stopRecordingbtn.isEnabled = false
        recordingLbl.text = "Tap to Record"
        
        /*-------------------AVAudio Functions start-------------------*/
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        /*-------------------AVAudio Functions end---------------------*/
    }
    
    /*---------Call stopRecording Segue(transfer the audio to the second scene) start------------*/
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("finish recording")
        if flag {  
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)  /* we call the stopRecording segue to send the path to  where audio file was located */
        } else {
            print("recodring was not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

    /*---------Call stopRecording Segue end ------------*/
}



