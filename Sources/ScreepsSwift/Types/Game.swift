import JavaScriptKit

public struct Game {
    private let jsObject: JSObject
    
    private init() {
        self.jsObject = ScreepsJS.Game
    }
    
    public static let shared = Game()
    
    public var time: Int {
        return Int(jsObject.time.number ?? 0)
    }
    
    public var creeps: [String: Creep] {
        var creepsDict: [String: Creep] = [:]
        let creepsJS = jsObject.creeps.object!
        
        let keys = JSObject.global.Object.function!.keys(creepsJS).object!
        let length = Int(keys.length.number ?? 0)
        
        for i in 0..<length {
            if let key = keys[i].string {
                if let creepJS = creepsJS[key].object {
                    creepsDict[key] = Creep(jsObject: creepJS, name: key)
                }
            }
        }
        
        return creepsDict
    }
    
    public var spawns: [String: JSObject] {
        var spawnsDict: [String: JSObject] = [:]
        let spawnsJS = jsObject.spawns.object!
        
        let keys = JSObject.global.Object.function!.keys(spawnsJS).object!
        let length = Int(keys.length.number ?? 0)
        
        for i in 0..<length {
            if let key = keys[i].string {
                if let spawnJS = spawnsJS[key].object {
                    spawnsDict[key] = spawnJS
                }
            }
        }
        
        return spawnsDict
    }
}