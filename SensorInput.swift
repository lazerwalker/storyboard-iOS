import Foundation

protocol SensorInput {
    typealias InputType
    func onChange(cb:(value:InputType) -> Void)
}
