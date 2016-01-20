//
//  ViewController.swift
//  FilbertSteps
//
//  Created by Mike Lazer-Walker on 12/28/15.
//  Copyright © 2015 Mike Lazer-Walker. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var stateLabel:UILabel?

    var game:Game?
    var activePassageId:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setMode(AVAudioSessionModeSpokenAudio)
        } catch {
            print("Error initializing audio session")
        }

        let inputs:[String:SensorInput] = [
            "proximity": ProximitySensor(threshold: 2),
            "headphones": HeadphoneSensor(),
            "altitude": AltimeterSensor(),
            "device": DeviceSensor()
        ]

        let outputs:[String:Output] = [
            "speech": TextToSpeechOutput(),
            "mp3": AudioOutput()
        ]

        let onStateUpdate:StateUpdateBlock = { state in
            print(state)
            if let stateLabel = self.stateLabel {
                stateLabel.text = state
                stateLabel.sizeToFit()
            }
        }

        let game = Game(inputs: inputs, outputs: outputs, onStateUpdate: onStateUpdate)
        self.game = game
        game.start()
    }
}

