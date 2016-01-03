import Foundation

protocol SensorInput {
    func onChange(cb:(value:AnyObject) -> Void)
}
