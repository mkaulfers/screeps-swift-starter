import JavaScriptKit

public struct Position {
    public let x: Int
    public let y: Int
    public let roomName: String
    
    var jsObject: JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.x = .number(Double(x))
        obj.y = .number(Double(y))
        obj.roomName = .string(roomName)
        return obj
    }
}

public struct Creep {
    private let jsObject: JSObject
    public let name: String
    
    init(jsObject: JSObject, name: String) {
        self.jsObject = jsObject
        self.name = name
    }
    
    public var pos: Position? {
        guard let posJS = jsObject.pos.object else { return nil }
        guard let x = posJS.x.number,
              let y = posJS.y.number,
              let roomName = posJS.roomName.string else { return nil }
        
        return Position(x: Int(x), y: Int(y), roomName: roomName)
    }
    
    public var energy: Int {
        if let store = jsObject.store.object,
           let energy = store.energy.number {
            return Int(energy)
        }
        return 0
    }
    
    public var energyCapacity: Int {
        if let store = jsObject.store.object {
            let capacity = store.getCapacity(.string("energy"))
            if let cap = capacity.number {
                return Int(cap)
            }
        }
        return 0
    }
    
    @discardableResult
    public func moveTo(_ target: JSObject) -> Int {
        let result = jsObject.moveTo(target)
        return Int(result.number ?? -1)
    }
    
    @discardableResult
    public func moveTo(x: Int, y: Int) -> Int {
        let result = jsObject.moveTo(.number(Double(x)), .number(Double(y)))
        return Int(result.number ?? -1)
    }
    
    @discardableResult
    public func harvest(_ source: JSObject) -> Int {
        let result = jsObject.harvest(source)
        return Int(result.number ?? -1)
    }
    
    @discardableResult
    public func transfer(_ target: JSObject, resourceType: String, amount: Int? = nil) -> Int {
        let resource = JSValue.string(resourceType)
        let result: JSValue
        
        if let amount = amount {
            result = jsObject.transfer(target, resource, .number(Double(amount)))
        } else {
            result = jsObject.transfer(target, resource)
        }
        
        return Int(result.number ?? -1)
    }
    
    @discardableResult
    public func build(_ target: JSObject) -> Int {
        let result = jsObject.build(target)
        return Int(result.number ?? -1)
    }
    
    @discardableResult
    public func repair(_ target: JSObject) -> Int {
        let result = jsObject.repair(target)
        return Int(result.number ?? -1)
    }
    
    @discardableResult
    public func upgradeController(_ target: JSObject) -> Int {
        let result = jsObject.upgradeController(target)
        return Int(result.number ?? -1)
    }
    
    public func say(_ message: String, public: Bool = false) {
        jsObject.say(.string(message), .boolean(public))
    }
}