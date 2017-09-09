import Foundation
import CoreMotion

class AltimeterSensor : SensorInput {
    let altimeter = CMAltimeter()

    var onChange:SensorInputBlock? {
        didSet {

        }
    }

    init() {
        // TODO: Manually manage a queue?
        if let queue = OperationQueue.current {
            altimeter.startRelativeAltitudeUpdates(to: queue) { (altitudeData, error) -> Void in
                if let data = altitudeData, let cb = self.onChange {
                    cb(data.relativeAltitude)
                }
            }
        }
    }
}
