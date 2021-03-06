import Foundation
import AVFoundation
import Storyboard

class HeadphoneSensor: Input {
    let session = AVAudioSession.sharedInstance()

    var callback:InputBlock?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(HeadphoneSensor.audioRouteChangeListener(_:)),
            name: NSNotification.Name.AVAudioSessionRouteChange,
            object: nil)

        checkOutputs()
    }

    func onChange(_ cb:@escaping InputBlock) {
        callback = cb
        checkOutputs()
    }

    fileprivate func checkOutputs() {
        let outputs = session.currentRoute.outputs

        // TODO: Do lightning EarPods work as expected?
        let headphones = outputs.filter({
            $0.portType == AVAudioSessionPortHeadphones ||
            $0.portType == AVAudioSessionPortBluetoothHFP ||
            $0.portType == AVAudioSessionPortBluetoothA2DP
        })
        if let cb = callback {
            cb(headphones.count > 0)
        }
    }

    @objc dynamic fileprivate func audioRouteChangeListener(_ notification:Notification) {
        checkOutputs()
    }
}
