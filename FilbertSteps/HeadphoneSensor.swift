import Foundation
import AVFoundation

class HeadphoneSensor: SensorInput {
    let session = AVAudioSession.sharedInstance()

    var callback:((AnyObject) -> Void)?

    init() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "audioRouteChangeListener:",
            name: AVAudioSessionRouteChangeNotification,
            object: nil)

        checkOutputs()
    }

    func onChange(cb:(value:AnyObject) -> Void) {
        callback = cb
        checkOutputs()
    }

    private func checkOutputs() {
        let outputs = session.currentRoute.outputs

        // TODO: Should I be allowing 
        // [AVAudioSessionPortBluetoothLE, AVAudioSessionPortBluetoothA2DP, AVAudioSessionPortLineOut]?
        let headphones = outputs.filter({ $0.portType == AVAudioSessionPortHeadphones })
        if let cb = callback {
            cb(headphones.count > 0)
        }
    }

    dynamic private func audioRouteChangeListener(notification:NSNotification) {
        checkOutputs()
    }
}