//
//  ViewController.swift
//  FilbertSteps
//
//  Created by Mike Lazer-Walker on 12/28/15.
//  Copyright © 2015 Mike Lazer-Walker. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate {
    let synthesizer = AVSpeechSynthesizer()

    var game:Game?
    var activePassageId:String?

    var audioPlayers:[AVAudioPlayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        synthesizer.delegate = self

        let game = Game()

        game.addOutput("textToSpeech") { (content, passageId) in
//            let utterance = AVSpeechUtterance(string: content)
//            self.synthesizer.speakUtterance(utterance)
//            self.activePassageId = passageId
            print("\(passageId): \"\(content)\"")
            game.completePassage(passageId)
        }

        game.addOutput("mp3") { (content, passageId) -> Void in
            let pathString = NSBundle.mainBundle().pathForResource(content, ofType: "mp3")
            if let pathString = pathString {
                let url = NSURL(fileURLWithPath: pathString)
                print(url)
                do {
                    let player = try AVAudioPlayer(contentsOfURL: url)
                    player.delegate = self
                    self.activePassageId = passageId
                    player.prepareToPlay()
                    print(player.play())
                    self.audioPlayers.append(player)
                } catch {
                    print("TODO: Error handling")
                }
            }
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

    // -
    // AVAudioPlayerDelegate
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Decode error \(error)")
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing file")
        if let passageId = activePassageId, game = self.game {
            game.completePassage(passageId)
        }
        audioPlayers.removeAtIndex(audioPlayers.indexOf(player)!)
    }
}

