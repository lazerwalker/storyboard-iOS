import Foundation

protocol SensorInput {
    /* As a SensorInput, you should store this callback
     * and call it whenever your data changes.
     *
     * By convention, your implementation of onChange should immediately call
     * the passed callback with the current/initial value of your sensor.
     */
    func onChange(cb:(value:AnyObject) -> Void)
}
