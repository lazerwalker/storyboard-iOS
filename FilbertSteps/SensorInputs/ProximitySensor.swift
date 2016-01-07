import Foundation
import UIKit

class ProximitySensor: NSObject, SensorInput {
    private var device = UIDevice.currentDevice()

    let threshold:NSTimeInterval

    var timer = NSTimer();

    var previousState = false
    var hasTriggered = false
    var callback:((AnyObject) -> Void)?
    var startTime:NSDate = NSDate()

    init(threshold:NSTimeInterval = 2) {
        self.threshold = threshold

        super.init()

        // TODO: We probably want to have startMonitoringProximity be a thing that
        // the dev manually enables, but I haven't thought through what that looks
        // like yet
        startMonitoringProximity()
    }

    func startMonitoringProximity() {
        device.proximityMonitoringEnabled = true

        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "checkProximity", userInfo: nil, repeats: true)
    }

    func stopMonitoringProximity() {
        device.proximityMonitoringEnabled = false
        timer.invalidate()
    }

    func onChange(cb:SensorInputBlock) {
        callback = cb

        if (device.proximityState) {
            cb(true)
            self.previousState = true
        } else {
            cb(false)
        }
        checkProximity()
    }
    
    //-

    func checkProximity() {
        let currentState = device.proximityState
        if(currentState && !previousState) {
            startTime = NSDate()
            hasTriggered = false
        } else if (currentState && previousState && !hasTriggered && abs(startTime.timeIntervalSinceNow) >= threshold) {
            hasTriggered = true
            if let cb = callback {
                cb(currentState)
            }
        } else if (!currentState && previousState) {
            if let cb = callback {
                cb(currentState)
            }
        }
        previousState = device.proximityState;
    }
}
