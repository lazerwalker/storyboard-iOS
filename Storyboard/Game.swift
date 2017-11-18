import Foundation
import JavaScriptCore

typealias StateUpdateBlock = (String) -> Void

class Game {
    fileprivate let context = JSContext()

    let inputs:[SensorInput]
    let outputs:[Output]

    var onStateUpdate: StateUpdateBlock?

    init(gameFile:String, inputs:[String:SensorInput], outputs:[String:Output], onStateUpdate:StateUpdateBlock?) {
        self.inputs = Array(inputs.values)
        self.outputs = Array(outputs.values)
        self.onStateUpdate = onStateUpdate

        let log: @convention(block) (String) -> Void = { string1 in
            print("log:\(string1)")
        }
        let setTimeout: @convention(block) (JSValue, JSValue) -> Void = { function, timeout in
            let delayTime = DispatchTime.now() + Double(Int64(timeout.toDouble() * Double(NSEC_PER_MSEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                function.call(withArguments: [])
            }
        }

        let stateUpdated: @convention(block) (String) -> Void = { state in
            print("State updated", state)
            if let cb = self.onStateUpdate {
                cb(state as String)
            }
        }

        context?.objectForKeyedSubscript("console").setObject(unsafeBitCast(log, to: AnyObject.self), forKeyedSubscript: "log" as (NSCopying & NSObjectProtocol)!);
        context?.setObject(unsafeBitCast(setTimeout, to: AnyObject.self), forKeyedSubscript: "setTimeout" as (NSCopying & NSObjectProtocol)!)
        context?.setObject(unsafeBitCast(stateUpdated, to: AnyObject.self), forKeyedSubscript: "stateUpdated" as (NSCopying & NSObjectProtocol)!)

        let path = Bundle.main.path(forResource: "bundle", ofType: "js")
        var gameString = ""
        do {
            gameString = try String(contentsOfFile: path!)
        }
        catch let error as NSError {
            print("ERROR: \(error.description)")
        }

        _ = context?.evaluateScript(gameString)
        let jsonPath = Bundle.main.path(forResource: gameFile, ofType: "story");
        var json = ""
        do {
            json = try String(contentsOfFile: jsonPath!)
        } catch let error as NSError {
            print("ERROR: \(error.description)")
        }

        context?.setObject(json, forKeyedSubscript: ("story" as NSString))
        _ = context?.evaluateScript("var game = new storyboard.Game(story)")

        _ = context?.evaluateScript("game.stateListener = stateUpdated")
        inputs.forEach({ addInput($0, sensor: $1) })
        outputs.forEach({ addOutput($0, output: $1) })
    }

    func start() {
        _ = context?.evaluateScript("game.start()")
    }

    func stop() {
        self.outputs.forEach { $0.stop() }
    }

    func completePassage(_ passageId:String) {
        context?.setObject(passageId, forKeyedSubscript: "passageId" as (NSCopying & NSObjectProtocol)!)
        _ = context?.evaluateScript("game.completePassage(passageId)")
    }

    //-
    fileprivate func addOutput(_ type:String, output:Output) {
        let fn : @convention(block) (String, String) -> Void = { content, passageId in
            let callback = {
                print("Completed \(type) passage \(passageId)")
                self.completePassage(passageId)
            }
            print("OUTPUT: (\(type)): \"\(content)\", \(passageId)")
            output.play(content, completionHandler:callback)
        }

        context?.setObject(type, forKeyedSubscript: "type" as (NSCopying & NSObjectProtocol)!);
        context?.setObject(unsafeBitCast(fn, to: AnyObject.self), forKeyedSubscript: "fn" as (NSCopying & NSObjectProtocol)!);
        _ = context?.evaluateScript("game.addOutput(type, fn)");
    }

    fileprivate func addInput(_ type:String, sensor:SensorInput) {
        sensor.onChange() { (value) in
            print("INPUT: \(type): \"\(value)\"")
            self.context?.setObject(value, forKeyedSubscript: ("input" as NSString))
            self.context?.setObject(type, forKeyedSubscript: ("sensor" as NSString))
            _ = self.context?.evaluateScript("game.receiveInput(sensor, input)")
        }
    }

}
