import Foundation
import UIKit

struct DeviceIdentifier {
    private var device = UIDevice.currentDevice()

    func deviceColor() {
        var selector:Selector = "deviceInfoForKey:"
        if (!device.respondsToSelector(selector)) {
            selector = "_deviceInfoForKey:"
        }

        if (!device.respondsToSelector(selector)) {
            return
        }

        print("Model name: \(device.modelName)")

        // See https://docs.google.com/spreadsheets/d/1yFjZvtNaV7cYOB_hRDjgPiNgQDZtMzaLAUhfxv449ZA/edit#gid=0
        print("Color:", device.performSelector("_deviceInfoForKey:", withObject: "DeviceColor"))
        print("Enclosure color:", device.performSelector("_deviceInfoForKey:", withObject: "DeviceEnclosureColor"))
    }
}