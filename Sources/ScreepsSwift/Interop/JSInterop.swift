import JavaScriptKit

public typealias JSValue = JavaScriptKit.JSValue
public typealias JSObject = JavaScriptKit.JSObject
public typealias JSClosure = JavaScriptKit.JSClosure
public typealias JSFunction = JavaScriptKit.JSFunction

public class ScreepsJS {
    public static let global = JSObject.global
    
    public static var Game: JSObject {
        return global.Game.object!
    }
    
    public static var Memory: JSObject {
        return global.Memory.object!
    }
    
    public static var module: JSObject {
        return global.module.object!
    }
    
    public static func exportLoop(_ closure: @escaping () -> Void) {
        let jsClosure = JSClosure { _ in
            closure()
            return .undefined
        }
        module.exports = .object(JSObject.global.Object.function!.new())
        module.exports.object!.loop = .object(jsClosure)
    }
}