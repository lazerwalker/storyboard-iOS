import Foundation
import CoreLocation

class MediaLabSensor : NSObject, SensorInput, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let mediaLab = CLLocation(latitude: 42.3608, longitude: -71.0877)

    var callback:SensorInputBlock?

    override init() {
        super.init()

        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }

    func onChange(cb: SensorInputBlock) {
        callback = cb

        if let location = manager.location {
            testLocation(location)
        }
    }

    func testLocation(location:CLLocation) {
        let val = (location.distanceFromLocation(mediaLab) < 100)
        if let cb = callback {
            cb(val)
        }
    }

    // -
    // CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            testLocation(location)
        }
    }
}
