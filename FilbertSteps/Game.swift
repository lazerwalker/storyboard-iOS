import Foundation
import JavaScriptCore

class Game {
    private let context = JSContext()

    var inputs:[SensorInput] = []
    var outputs:[Output] = []

    var onStateUpdate: ((String) -> Void)?

    init() {
        let log: @convention(block) (String) -> Void = { string1 in
            print("log:\(string1)")
        }
        let setTimeout: @convention(block) (JSValue, JSValue) -> Void = { function, timeout in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout.toDouble() * Double(NSEC_PER_MSEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                function.callWithArguments([])
            }
        }

        let stateUpdated: @convention(block) (String) -> Void = { state in
            if let cb = self.onStateUpdate {
                cb(state as String)
            }
        }

        context.objectForKeyedSubscript("console").setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "log");
        context.setObject(unsafeBitCast(setTimeout, AnyObject.self), forKeyedSubscript: "setTimeout")
        context.setObject(unsafeBitCast(stateUpdated, AnyObject.self), forKeyedSubscript: "stateUpdated")

        let path = NSBundle.mainBundle().pathForResource("dist", ofType: "js")
        var gameString = ""
        do {
            gameString = try String(contentsOfFile: path!)
        }
        catch let error as NSError {
            error.description
        }

        context.evaluateScript(gameString)

        let jsonPath = NSBundle.mainBundle().pathForResource("data", ofType: "json");
        var json = ""
        do {
            json = try String(contentsOfFile: jsonPath!)
        } catch let error as NSError {
            error.description
        }

        context.setObject(json, forKeyedSubscript: "json")
        context.evaluateScript("var data = JSON.parse(json)")
        context.evaluateScript("var game = new Game(data)")
        context.evaluateScript("game.stateListener = stateUpdated")
    }

    func start() {
        context.evaluateScript("game.start()")
    }

    func addOutput(type:String, output:Output) {
        let fn : @convention(block) (String, String) -> Void = { content, passageId in
            let callback = {
                self.completePassage(passageId)
            }
            output.play(content, completionHandler:callback)
        }

        context.setObject(type, forKeyedSubscript: "type");
        context.setObject(unsafeBitCast(fn, AnyObject.self), forKeyedSubscript: "fn");
        context.evaluateScript("game.addOutput(type, fn)");

        outputs.append(output)
    }

    func addInput(type:String, sensor:SensorInput) {
        sensor.onChange { (value) -> Void in
            print("\(type): \"\(value)\"")
            self.context.setObject(value, forKeyedSubscript: "input")
            self.context.setObject(type, forKeyedSubscript: "sensor")
            self.context.evaluateScript("game.receiveInput(sensor, input)")
        }

        inputs.append(sensor)
    }

    func addInputs(inputs:[String:SensorInput]) {
        inputs.forEach { (type, sensor) -> () in
            self.addInput(type, sensor: sensor)
        }
    }

    func addOutputs(outputs:[String:Output]) {
        outputs.forEach { (type, output) -> () in
            self.addOutput(type, output: output)
        }
    }

    func completePassage(passageId:String) {
        context.setObject(passageId, forKeyedSubscript: "passageId")
        context.evaluateScript("game.completePassage(passageId)")
    }
}
