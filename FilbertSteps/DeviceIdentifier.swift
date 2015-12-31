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

        print(device.modelName)

        // See https://docs.google.com/spreadsheets/d/1yFjZvtNaV7cYOB_hRDjgPiNgQDZtMzaLAUhfxv449ZA/edit#gid=0
        print(device.performSelector("_deviceInfoForKey:", withObject: "DeviceColor"))
        print(device.performSelector("_deviceInfoForKey:", withObject: "DeviceEnclosureColor"))
    }
}