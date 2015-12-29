import Foundation
import JavaScriptCore

class Game {
    let context = JSContext()

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

        context.objectForKeyedSubscript("console").setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "log");
        context.setObject(unsafeBitCast(setTimeout, AnyObject.self), forKeyedSubscript: "setTimeout")

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
        context.evaluateScript("var game = new Game.default(data)")
        context.evaluateScript("game.addOutput('audio', function(a, b) { console.log(a, b) })");
        context.evaluateScript("game.start()")
    }
}
