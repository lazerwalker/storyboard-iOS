import Foundation
import JavaScriptCore

public typealias StateUpdateBlock = (String) -> Void
public typealias ObserverBlock = (Any?) -> Void

public class Game {
    fileprivate let context = JSContext()

    public let inputs:[Input]
    public let outputs:[Output]
    public let observers:[ObserverBlock]

    public var onStateUpdate: StateUpdateBlock?

    public init(story:String, inputs:[String:Input]?, outputs:[String:Output]?, observers:[String:ObserverBlock]?, onStateUpdate:StateUpdateBlock?) {
        if let inputs = inputs {
            self.inputs = Array(inputs.values)
        } else {
            self.inputs = []
        }

        if let outputs = outputs {
            self.outputs = Array(outputs.values)
        } else {
            self.outputs = []
        }
        
        if let observers = observers {
            self.observers = Array(observers.values)
        } else {
            self.observers = []
        }

        self.onStateUpdate = onStateUpdate

        setupJSEnvironment()

        // Load engine
        let path = Bundle(for: Game.self).path(forResource: "bundle", ofType: "js")
        var bundle = ""
        do {
            bundle = try String(contentsOfFile: path!)
        }
        catch let error as NSError {
            print("ERROR: \(error.description)")
        }

        _ = context?.evaluateScript(bundle)

        // Load story
        context?.setObject(story, forKeyedSubscript: ("story" as NSString))
        _ = context?.evaluateScript("var game = new storyboard.Game(story)")

        let stateUpdated: @convention(block) (String) -> Void = { state in
            if let cb = self.onStateUpdate {
                cb(state)
            }
        }


        if let inputs = inputs {
            inputs.forEach({ addInput($0, sensor: $1) })
        }

        if let outputs = outputs {
            outputs.forEach({ addOutput($0, output: $1) })
        }
        
        if let observers = observers {
            observers.forEach({ addObserver($0, observer: $1) })
        }

        context?.setObject(unsafeBitCast(stateUpdated, to: AnyObject.self), forKeyedSubscript: "stateUpdated" as (NSCopying & NSObjectProtocol)!)
        _ = context?.evaluateScript("game.stateListener = stateUpdated")
    }

    public func start() {
        _ = context?.evaluateScript("game.start()")
    }

    public func stop() {
        self.outputs.forEach { $0.stop() }
    }

    public func completePassage(_ passageId:String) {
        context?.setObject(passageId, forKeyedSubscript: "passageId" as (NSCopying & NSObjectProtocol)!)
        _ = context?.evaluateScript("game.completePassage(passageId)")
    }

    public func receiveInput(_ dict: [String: Any]) {
        dict.forEach { (type, value) in
            self.context?.setObject(value, forKeyedSubscript: "input" as NSString)
            self.context?.setObject(type, forKeyedSubscript: "sensor" as NSString)
            _ = self.context?.evaluateScript("game.receiveInput(sensor, input)")
        }
    }

    //-
    fileprivate func setupJSEnvironment() {
        let log: @convention(block) (String) -> Void = { string1 in
            print("log:\(string1)")
        }
        let setTimeout: @convention(block) (JSValue, JSValue) -> Void = { function, timeout in
            let delayTime = DispatchTime.now() + Double(Int64(timeout.toDouble() * Double(NSEC_PER_MSEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                function.call(withArguments: [])
            }
        }

        context?.objectForKeyedSubscript("console").setObject(unsafeBitCast(log, to: AnyObject.self), forKeyedSubscript: "log" as (NSCopying & NSObjectProtocol)!);
        context?.setObject(unsafeBitCast(setTimeout, to: AnyObject.self), forKeyedSubscript: "setTimeout" as (NSCopying & NSObjectProtocol)!)
    }

    fileprivate func addOutput(_ type:String, output:Output) {
        let fn : @convention(block) (String, String) -> Void = { content, passageId in
            let callback = {
                print("Completed \(type) passage \(passageId)")
                self.completePassage(passageId)
            }
            print("OUTPUT: (\(type)): \"\(content)\", \(passageId)")
            output.play(content, completionHandler:callback)
        }

        context?.setObject(type, forKeyedSubscript: "type" as NSString);
        context?.setObject(unsafeBitCast(fn, to: AnyObject.self), forKeyedSubscript: "fn" as NSString);
        _ = context?.evaluateScript("game.addOutput(type, fn)");
    }

    fileprivate func addInput(_ type:String, sensor:Input) {
        sensor.onChange() { (value) in
            print("INPUT: \(type): \"\(value)\"")
            self.context?.setObject(value, forKeyedSubscript: "input" as NSString)
            self.context?.setObject(type, forKeyedSubscript: "sensor" as NSString)
            _ = self.context?.evaluateScript("game.receiveInput(sensor, input)")
        }
    }
    
    fileprivate func addObserver(_ type:String, observer:@escaping ObserverBlock) {
        context?.setObject(type, forKeyedSubscript: "type" as NSString);
        let fn : @convention(block) (Any?) -> Void = observer
        context?.setObject(unsafeBitCast(fn, to: AnyObject.self), forKeyedSubscript: "fn" as NSString);
        _ = context?.evaluateScript("game.addObserver(type, fn)");
    }
    
    // TODO: Will this work? Is the callback the same?
    fileprivate func removeObserver(_ type:String, observer:ObserverBlock) {
        context?.setObject(type, forKeyedSubscript: "type" as NSString);
        context?.setObject(unsafeBitCast(observer, to: AnyObject.self), forKeyedSubscript: "fn" as NSString);
        _ = context?.evaluateScript("game.removeObserver(type, fn)");
    }
}
