import Foundation
import AVFoundation

// TODO: This shouldn't need to be an NSObject
// but for now it's the easiest way to stop Swift from complaining about noncompliance with NSObjectProtocol
class AudioOutput : NSObject, Output, AVAudioPlayerDelegate {

    var audioPlayers:[AVAudioPlayer] =  []

    var completionHandler:OutputCompletionBlock?
    var project:String

    init(project:String) {
        self.project = project

        super.init()
    }

    func play(content: String, completionHandler: OutputCompletionBlock) {
        self.completionHandler = completionHandler

        let pathString = NSBundle.mainBundle().pathForResource(content, ofType: "mp3", inDirectory: "examples/\(project)")

        if let pathString = pathString {
            let url = NSURL(fileURLWithPath: pathString)
            print(url)
            do {
                let player = try AVAudioPlayer(contentsOfURL: url)
                player.delegate = self
                player.prepareToPlay()
                player.play()
                self.audioPlayers.append(player)
            } catch {
                print("TODO: Error handling")
            }
        }

    }

    func stop() {
        audioPlayers.forEach { $0.stop() }
    }

    // -
    // AVAudioPlayerDelegate
    dynamic func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Decode error \(error)")
    }

    dynamic func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing file")
        if let cb = completionHandler {
            cb()
        }
        audioPlayers.removeAtIndex(audioPlayers.indexOf(player)!)
    }
}