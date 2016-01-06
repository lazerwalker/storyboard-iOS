import Foundation
import CoreMotion

class AltimeterSensor : SensorInput {
    let altimeter = CMAltimeter()

    var callback:((AnyObject) -> Void)?

    init() {
        // TODO: Manually manage a queue?
        if let queue = NSOperationQueue.currentQueue() {
            altimeter.startRelativeAltitudeUpdatesToQueue(queue) { (altitudeData, error) -> Void in
                if let data = altitudeData, cb = self.callback {
                    cb(data.relativeAltitude)
                }
            }
        }
    }

    func onChange(cb: (value: AnyObject) -> Void) {
        callback = cb
    }
}
