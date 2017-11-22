import Foundation
import UIKit
import Storyboard

struct DeviceSensor : Input {
    internal var onChange: InputBlock?

    fileprivate var device = UIDevice.current

    func onChange(_ cb: @escaping InputBlock) {
        cb(device.modelName as AnyObject)
    }

    func deviceColor() {
        var selector:Selector = "deviceInfoForKey:"
        if (!device.responds(to: selector)) {
            selector = "_deviceInfoForKey:"
        }

        if (!device.responds(to: selector)) {
            return
        }

        print("Model name: \(device.modelName)")

        // See https://docs.google.com/spreadsheets/d/1yFjZvtNaV7cYOB_hRDjgPiNgQDZtMzaLAUhfxv449ZA/edit#gid=0
        print("Color:", device.perform("_deviceInfoForKey:", with: "DeviceColor"))
        print("Enclosure color:", device.perform("_deviceInfoForKey:", with: "DeviceEnclosureColor"))
    }
}
