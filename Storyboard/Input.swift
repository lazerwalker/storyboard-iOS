import Foundation

public typealias InputBlock = (Any) -> Void

public protocol Input {
    /* As an Input, you should store the passed-in InputBlock
     * and call it whenever your data changes.
     *
     * By convention, your implementation of onChange should immediately call
     * the passed callback with the current/initial value of your sensor.
     */
    func onChange(_: @escaping InputBlock)
}
