import Foundation
import UIKit

class ProximitySensor:NSObject {
    private var kvoContext: UInt8 = 1
    private var device = UIDevice.currentDevice()

    let threshold:NSTimeInterval

    var timer = NSTimer();

    var previousState = false
    var hasTriggered = false
    var callback:((Bool) -> Void)?
    var startTime:NSDate = NSDate()


    init(threshold:NSTimeInterval = 2) {
        self.threshold = threshold

        super.init()
    }

    func startMonitoringProximity() {
        device.proximityMonitoringEnabled = true

        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "checkProximity", userInfo: nil, repeats: true)
    }

    func stopMonitoringProximity() {
        device.proximityMonitoringEnabled = false
        timer.invalidate()
    }

    func onChange(cb:(value:Bool) -> Void) {
        callback = cb
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
