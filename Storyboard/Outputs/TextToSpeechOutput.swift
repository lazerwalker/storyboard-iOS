import Foundation
import AVFoundation

// TODO: This shouldn't need to be an NSObject
// but for now it's the easiest way to stop Swift from complaining about noncompliance with NSObjectProtocol
class TextToSpeechOutput : NSObject, Output, AVSpeechSynthesizerDelegate {

    let synthesizer = AVSpeechSynthesizer()

    var completionHandler: OutputCompletionBlock?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func play(_ content: String, completionHandler: @escaping OutputCompletionBlock) {
        self.completionHandler = completionHandler

        let utterance = AVSpeechUtterance(string: content)
        self.synthesizer.speak(utterance)
    }

    func stop() {
        self.synthesizer.stopSpeaking(at: .immediate)
    }

    //-
    // AVSpeechSynthesizerDelegate

    dynamic func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let cb = completionHandler {
            cb()
        }
    }

}
