//
//  ViewController.swift
//  FilbertSteps
//
//  Created by Mike Lazer-Walker on 12/28/15.
//  Copyright © 2015 Mike Lazer-Walker. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    let synthesizer = AVSpeechSynthesizer()

    var game:Game?
    var activePassageId:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        synthesizer.delegate = self

        let game = Game()

        game.addOutput("audio") { (content, passageId) in
            let utterance = AVSpeechUtterance(string: content)
            self.synthesizer.speakUtterance(utterance)
            self.activePassageId = passageId
            print("\(passageId): \"\(content)\"")
        }

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

    //-
    // AVSpeechSynthesizerDelegate

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        print("Finished speaking")
        if let passageId = activePassageId, game = self.game {
            game.completePassage(passageId)
        }
    }
}

