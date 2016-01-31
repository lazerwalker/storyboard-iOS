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

    var projectName:String?

    var playButton:UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "start")
        navigationItem.rightBarButtonItem = playButton

        loadProject("elevator")
    }

    //- 

    func loadProject(projectName:String) {
        self.projectName = projectName
        self.title = projectName
        
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
            "device": DeviceSensor(),
            "insideTheMediaLab": MediaLabSensor()
        ]

        let outputs:[String:Output] = [
            "speech": TextToSpeechOutput(),
            "mp3": AudioOutput(project: projectName)
        ]

        let onStateUpdate:StateUpdateBlock = { state in
            if let stateLabel = self.stateLabel {
                stateLabel.text = state
                stateLabel.sizeToFit()
            }
        }

        let game = Game(gameFile: projectName, inputs: inputs, outputs: outputs, onStateUpdate: onStateUpdate)
        self.game = game
    }

    func start() {
        if let game = game {
            game.start()
            playButton?.enabled = false
        }
    }
}

