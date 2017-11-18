import Foundation
import CoreMotion

class AltimeterSensor : SensorInput {
    let altimeter = CMAltimeter()
    var lastData: CMAltitudeData?

    var onChange:SensorInputBlock?

    func onChange(_ block: @escaping SensorInputBlock) {
        onChange = block
        if let data = lastData {
            block(data)
        }
    }

    init() {
        // TODO: Manually manage a queue?
        if let queue = OperationQueue.current {
            altimeter.startRelativeAltitudeUpdates(to: queue) { (altitudeData, error) -> Void in
                self.lastData = altitudeData
                if let data = altitudeData, let cb = self.onChange {
                    cb(data.relativeAltitude)
                }
            }
        }
    }
}
