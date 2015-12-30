import Foundation
import UIKit

class ProximitySensor:NSObject {
    private var kvoContext: UInt8 = 1
    private var device = UIDevice.currentDevice()

    override init() {
        super.init()

        device.proximityMonitoringEnabled = true
        device.addObserver(self, forKeyPath: "proximityState",
            options: .New, context: &kvoContext)
    }

    deinit {
        device.removeObserver(self, forKeyPath: "proximityState")
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &kvoContext {
            print("Change at keyPath = \(keyPath) for \(object)")
        }

    }
}
