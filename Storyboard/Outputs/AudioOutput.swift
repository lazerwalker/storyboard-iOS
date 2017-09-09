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

    func play(_ content: String, completionHandler: @escaping OutputCompletionBlock) {
        self.completionHandler = completionHandler

        let pathString = Bundle.main.path(forResource: content, ofType: "mp3", inDirectory: "examples/\(project)")

        if let pathString = pathString {
            let url = URL(fileURLWithPath: pathString)
            print(url)
            do {
                let player = try AVAudioPlayer(contentsOf: url)
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
    dynamic func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Decode error \(error)")
    }

    dynamic func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing file")
        if let cb = completionHandler {
            cb()
        }
        audioPlayers.remove(at: audioPlayers.index(of: player)!)
    }
}
