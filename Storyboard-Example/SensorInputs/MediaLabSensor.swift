import Foundation
import CoreLocation
import Storyboard

class MediaLabSensor : NSObject, Input, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let mediaLab = CLLocation(latitude: 42.3608, longitude: -71.0877)

    var callback:InputBlock?

    override init() {
        super.init()

        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }

    func onChange(_ cb: @escaping InputBlock) {
        callback = cb

        if let location = manager.location {
            testLocation(location)
        }
    }

    func testLocation(_ location:CLLocation) {
        let val = (location.distance(from: mediaLab) < 100)
        if let cb = callback {
            cb(val)
        }
    }

    // -
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            testLocation(location)
        }
    }
}
