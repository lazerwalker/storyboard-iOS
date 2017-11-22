import Foundation
import CoreMotion
import Storyboard

class AltimeterSensor : Input {
    let altimeter = CMAltimeter()
    var lastData: CMAltitudeData?

    var onChange:InputBlock?

    func onChange(_ block: @escaping InputBlock) {
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
