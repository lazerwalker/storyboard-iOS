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
    var restartButton:UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "start")
        restartButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "restart")

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showGamePicker")

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

        self.game?.stop()
        let game = Game(gameFile: projectName, inputs: inputs, outputs: outputs, onStateUpdate: onStateUpdate)
        self.game = game

        navigationItem.rightBarButtonItem = playButton
    }

    func start() {
        if let game = game {
            game.start()
            navigationItem.rightBarButtonItem = restartButton
        }
    }

    func restart() {
        if let name = projectName {
            loadProject(name)
            start()
        }
    }

    func showGamePicker() {
        let paths = NSBundle.mainBundle()
            .pathsForResourcesOfType("json", inDirectory: "examples")
            .flatMap { $0.componentsSeparatedByString("/").last }
            .flatMap { $0.componentsSeparatedByString(".").first }

        let vc = ProjectListViewController(projects: paths) { project in
            if let project = project {
                self.loadProject(project)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }
}

