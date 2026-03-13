import JavaScriptKit

public typealias JSValue = JavaScriptKit.JSValue
public typealias JSObject = JavaScriptKit.JSObject
public typealias JSClosure = JavaScriptKit.JSClosure

protocol JSBacked {
    var jsObject: JSObject { get }
    init?(jsObject: JSObject)
}

enum JSBridge {
    static let global = JSObject.global
    private static let objectKeys = JSObject.global.Object.function!.keys.function!

    static func keys(of object: JSObject) -> [String] {
        let jsKeys = objectKeys(object).object!
        let length = Int(jsKeys.length.number ?? 0)
        return (0..<length).compactMap { jsKeys[$0].string }
    }

    static func int(_ value: JSValue) -> Int? {
        value.number.map(Int.init)
    }

    static func double(_ value: JSValue) -> Double? {
        value.number
    }

    static func bool(_ value: JSValue) -> Bool? {
        value.boolean
    }

    static func string(_ value: JSValue) -> String? {
        value.string
    }

    static func arrayValues(_ value: JSValue) -> [JSValue] {
        guard let array = value.object else {
            return []
        }

        let length = Int(array.length.number ?? 0)
        return (0..<length).map { array[$0] }
    }

    static func typedArray<T: JSBacked>(_ value: JSValue, as type: T.Type = T.self) -> [T] {
        arrayValues(value).compactMap { $0.object }.compactMap(T.init)
    }

    static func typedDictionary<T: JSBacked>(_ object: JSObject, as type: T.Type = T.self) -> [String: T] {
        var result: [String: T] = [:]
        for key in keys(of: object) {
            if let jsObject = object[key].object, let typed = T(jsObject: jsObject) {
                result[key] = typed
            }
        }
        return result
    }

    static func makePlainObject(fields: [String: JSValue]) -> JSObject {
        let object = JSObject.global.Object.function!.new()
        for (key, value) in fields {
            object[key] = value
        }
        return object
    }
}
