import Foundation

public typealias OutputCompletionBlock = () -> Void

public protocol Output {
    /**
     * content: The string of actual output content
     * (this might represent e.g. the name of an audio filename to play)
     *
     * completed: A callback to call when the output is finished
     * TODO: It should probably take in a success boolean and/or error object
    */
    func play(_ content:String, track: String, completionHandler: @escaping OutputCompletionBlock)

    func stop()
}
