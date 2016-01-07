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

        let game = Game()

        game.onStateUpdate = { state in
            print(state)
            if let stateLabel = self.stateLabel {
                stateLabel.text = state
                stateLabel.sizeToFit()
            }
        }

        game.addOutputs([
            "speech": TextToSpeechOutput(),
            "mp3": AudioOutput()
        ])

        game.addInputs([
            "proximity": ProximitySensor(threshold: 2),
            "headphones": HeadphoneSensor(),
            "altimeter": AltimeterSensor(),
            "device": DeviceSensor()
        ])

        self.game = game
        game.start()
    }
}

