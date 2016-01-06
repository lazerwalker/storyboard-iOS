//
//  ViewController.swift
//  FilbertSteps
//
//  Created by Mike Lazer-Walker on 12/28/15.
//  Copyright © 2015 Mike Lazer-Walker. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    let synthesizer = AVSpeechSynthesizer()

    var game:Game?
    var activePassageId:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let game = Game()

        game.addOutputs([
            "textToSpeech": TextToSpeechOutput(),
            "mp3": AudioOutput()
        ])

        game.addInputs([
            "proximity": ProximitySensor(threshold: 2),
            "headphones": HeadphoneSensor(),
            "altimeter": Altimeter()
        ])

        let device = DeviceIdentifier()
        device.deviceColor()
        
        self.game = game
        game.start()

    }
}

