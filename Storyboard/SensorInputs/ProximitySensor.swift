import Foundation
import UIKit

class ProximitySensor: NSObject, SensorInput {
    fileprivate var device = UIDevice.current

    let threshold:TimeInterval

    var timer = Timer();

    var previousState = false
    var hasTriggered = false
    var callback:((AnyObject) -> Void)?
    var startTime:Date = Date()

    init(threshold:TimeInterval = 2) {
        self.threshold = threshold

        super.init()

        // TODO: We probably want to have startMonitoringProximity be a thing that
        // the dev manually enables, but I haven't thought through what that looks
        // like yet
        startMonitoringProximity()
    }

    func startMonitoringProximity() {
        device.isProximityMonitoringEnabled = true

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ProximitySensor.checkProximity), userInfo: nil, repeats: true)
    }

    func stopMonitoringProximity() {
        device.isProximityMonitoringEnabled = false
        timer.invalidate()
    }

    func onChange(_ cb:@escaping SensorInputBlock) {
        callback = cb

        if (device.proximityState) {
            cb(true as AnyObject)
            self.previousState = true
        } else {
            cb(false as AnyObject)
        }
        checkProximity()
    }
    
    //-

    func checkProximity() {
        let currentState = device.proximityState
        if(currentState && !previousState) {
            startTime = Date()
            hasTriggered = false
        } else if (currentState && previousState && !hasTriggered && abs(startTime.timeIntervalSinceNow) >= threshold) {
            hasTriggered = true
            if let cb = callback {
                cb(currentState as AnyObject)
            }
        } else if (!currentState && previousState) {
            if let cb = callback {
                cb(currentState as AnyObject)
            }
        }
        previousState = device.proximityState;
    }
}
