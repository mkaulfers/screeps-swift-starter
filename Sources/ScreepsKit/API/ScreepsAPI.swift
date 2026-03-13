import JavaScriptKit

public protocol HasPosition {
    var pos: RoomPosition { get }
}

public protocol HasStore {
    var store: Store { get }
}

public struct ObjectID<ObjectType>: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension ReturnCode {
    var jsValue: JSValue {
        .number(Double(rawValue))
    }

    var isSuccess: Bool {
        self == .ok
    }
}

public extension FindConstant {
    var jsValue: JSValue {
        .number(Double(rawValue))
    }
}

public extension Direction {
    var jsValue: JSValue {
        .number(Double(rawValue))
    }
}

public extension ResourceType {
    var jsValue: JSValue {
        .string(rawValue)
    }
}

public extension StructureType {
    var jsValue: JSValue {
        .string(rawValue)
    }
}

public struct RoomPosition: JSBacked, HasPosition, Hashable {
    let jsObject: JSObject

    public init(x: Int, y: Int, roomName: String) {
        self.jsObject = JSBridge.makePlainObject(
            fields: [
                "x": .number(Double(x)),
                "y": .number(Double(y)),
                "roomName": .string(roomName),
            ]
        )
    }

    init?(jsObject: JSObject) {
        guard JSBridge.int(jsObject.x) != nil, JSBridge.int(jsObject.y) != nil, JSBridge.string(jsObject.roomName) != nil else {
            return nil
        }
        self.jsObject = jsObject
    }

    public var x: Int {
        JSBridge.int(jsObject.x) ?? 0
    }

    public var y: Int {
        JSBridge.int(jsObject.y) ?? 0
    }

    public var roomName: String {
        JSBridge.string(jsObject.roomName) ?? ""
    }

    public var pos: RoomPosition {
        self
    }

    public func isNear(to other: RoomPosition) -> Bool {
        abs(x - other.x) <= 1 && abs(y - other.y) <= 1 && roomName == other.roomName
    }

    public static func == (lhs: RoomPosition, rhs: RoomPosition) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.roomName == rhs.roomName
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(roomName)
        hasher.combine(x)
        hasher.combine(y)
    }
}

public struct Store: JSBacked {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public subscript(resource: ResourceType) -> Int {
        JSBridge.int(jsObject[resource.rawValue]) ?? 0
    }

    public func usedCapacity(for resource: ResourceType? = nil) -> Int {
        if let resource {
            return JSBridge.int(jsObject.getUsedCapacity.function!(resource.rawValue)) ?? 0
        }
        return JSBridge.int(jsObject.getUsedCapacity.function!()) ?? 0
    }

    public func freeCapacity(for resource: ResourceType? = nil) -> Int {
        if let resource {
            return JSBridge.int(jsObject.getFreeCapacity.function!(resource.rawValue)) ?? 0
        }
        return JSBridge.int(jsObject.getFreeCapacity.function!()) ?? 0
    }

    public func capacity(for resource: ResourceType? = nil) -> Int {
        if let resource {
            return JSBridge.int(jsObject.getCapacity.function!(resource.rawValue)) ?? 0
        }
        return JSBridge.int(jsObject.getCapacity.function!()) ?? 0
    }
}

public struct ScreepsMemory {
    let jsObject: JSObject

    public subscript(key: String) -> String? {
        get {
            JSBridge.string(jsObject[key])
        }
        nonmutating set {
            if let newValue {
                jsObject[key] = .string(newValue)
            } else {
                jsObject[key] = .undefined
            }
        }
    }
}

public struct RawMemoryProxy {
    let jsObject: JSObject

    public func get() -> String {
        JSBridge.string(jsObject.get.function!()) ?? ""
    }

    public func set(_ value: String) {
        _ = jsObject.set.function!(value)
    }
}

public struct CPU: JSBacked {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var limit: Int {
        JSBridge.int(jsObject.limit) ?? 0
    }

    public var tickLimit: Int {
        JSBridge.int(jsObject.tickLimit) ?? 0
    }

    public var bucket: Int {
        JSBridge.int(jsObject.bucket) ?? 0
    }

    public func getUsed() -> Double {
        JSBridge.double(jsObject.getUsed.function!()) ?? 0
    }
}

public struct RoomObject: JSBacked, HasPosition {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }
}

public struct Source: JSBacked, HasPosition {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var id: ObjectID<Source>? {
        JSBridge.string(jsObject.id).map(ObjectID.init(rawValue:))
    }

    public var energy: Int {
        JSBridge.int(jsObject.energy) ?? 0
    }

    public var energyCapacity: Int {
        JSBridge.int(jsObject.energyCapacity) ?? 0
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }
}

public struct Flag: JSBacked, HasPosition {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var name: String {
        JSBridge.string(jsObject.name) ?? ""
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }
}

public struct ConstructionSite: JSBacked, HasPosition {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var id: ObjectID<ConstructionSite>? {
        JSBridge.string(jsObject.id).map(ObjectID.init(rawValue:))
    }

    public var structureType: StructureType? {
        JSBridge.string(jsObject.structureType).flatMap(StructureType.init(rawValue:))
    }

    public var progress: Int {
        JSBridge.int(jsObject.progress) ?? 0
    }

    public var progressTotal: Int {
        JSBridge.int(jsObject.progressTotal) ?? 0
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }
}

public struct Structure: JSBacked, HasPosition {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var id: ObjectID<Structure>? {
        JSBridge.string(jsObject.id).map(ObjectID.init(rawValue:))
    }

    public var structureType: StructureType? {
        JSBridge.string(jsObject.structureType).flatMap(StructureType.init(rawValue:))
    }

    public var hits: Int {
        JSBridge.int(jsObject.hits) ?? 0
    }

    public var hitsMax: Int {
        JSBridge.int(jsObject.hitsMax) ?? 0
    }

    public var room: Room? {
        jsObject.room.object.flatMap(Room.init)
    }

    public var store: Store? {
        jsObject.store.object.flatMap(Store.init)
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }
}

public struct StructureController: JSBacked, HasPosition {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var level: Int {
        JSBridge.int(jsObject.level) ?? 0
    }

    public var progress: Int {
        JSBridge.int(jsObject.progress) ?? 0
    }

    public var progressTotal: Int {
        JSBridge.int(jsObject.progressTotal) ?? 0
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }
}

public struct StructureSpawn: JSBacked, HasPosition, HasStore {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var id: ObjectID<StructureSpawn>? {
        JSBridge.string(jsObject.id).map(ObjectID.init(rawValue:))
    }

    public var name: String {
        JSBridge.string(jsObject.name) ?? ""
    }

    public var store: Store {
        Store(jsObject: jsObject.store.object!)!
    }

    public var structureType: StructureType {
        .spawn
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }
}

public struct StructureExtension: JSBacked, HasPosition, HasStore {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var id: ObjectID<StructureExtension>? {
        JSBridge.string(jsObject.id).map(ObjectID.init(rawValue:))
    }

    public var store: Store {
        Store(jsObject: jsObject.store.object!)!
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }
}

public struct Room: JSBacked {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var name: String {
        JSBridge.string(jsObject.name) ?? ""
    }

    public var controller: StructureController? {
        jsObject.controller.object.flatMap(StructureController.init)
    }

    public var sources: [Source] {
        findObjects(.sources, as: Source.self)
    }

    public var activeSources: [Source] {
        findObjects(.sourcesActive, as: Source.self)
    }

    public var mySpawns: [StructureSpawn] {
        findObjects(.mySpawns, as: StructureSpawn.self)
    }

    public var myConstructionSites: [ConstructionSite] {
        findObjects(.myConstructionSites, as: ConstructionSite.self)
    }

    public var flags: [Flag] {
        findObjects(.flags, as: Flag.self)
    }

    public var myExtensions: [StructureExtension] {
        findObjects(.myStructures, as: StructureExtension.self)
            .filter { extensionStructure in
                JSBridge.string(extensionStructure.jsObject.structureType) == StructureType.structureExtension.rawValue
            }
    }

    public var myStructures: [Structure] {
        findObjects(.myStructures, as: Structure.self)
    }

    internal func findObjects<T: JSBacked>(_ constant: FindConstant, as type: T.Type = T.self) -> [T] {
        JSBridge.typedArray(jsObject.find.function!(constant.rawValue), as: type)
    }
}

public struct Creep: JSBacked, HasPosition, HasStore {
    let jsObject: JSObject

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var id: ObjectID<Creep>? {
        JSBridge.string(jsObject.id).map(ObjectID.init(rawValue:))
    }

    public var name: String {
        JSBridge.string(jsObject.name) ?? ""
    }

    public var pos: RoomPosition {
        RoomPosition(jsObject: jsObject.pos.object!)!
    }

    public var room: Room? {
        jsObject.room.object.flatMap(Room.init)
    }

    public var store: Store {
        Store(jsObject: jsObject.store.object!)!
    }

    public var hits: Int {
        JSBridge.int(jsObject.hits) ?? 0
    }

    public var hitsMax: Int {
        JSBridge.int(jsObject.hitsMax) ?? 0
    }

    public var spawning: Bool {
        JSBridge.bool(jsObject.spawning) ?? false
    }

    @discardableResult
    public func moveTo(_ target: some HasPosition) -> ReturnCode {
        roomMoveTo(target.pos)
    }

    @discardableResult
    public func moveTo(_ x: Int, _ y: Int) -> ReturnCode {
        returnCode(from: jsObject.moveTo.function!(x, y))
    }

    @discardableResult
    public func harvest(_ source: Source) -> ReturnCode {
        returnCode(from: jsObject.harvest.function!(source.jsObject))
    }

    @discardableResult
    public func transfer(_ target: StructureSpawn, resource: ResourceType, amount: Int? = nil) -> ReturnCode {
        transfer(target.jsObject, resource: resource, amount: amount)
    }

    @discardableResult
    public func transfer(_ target: StructureExtension, resource: ResourceType, amount: Int? = nil) -> ReturnCode {
        transfer(target.jsObject, resource: resource, amount: amount)
    }

    @discardableResult
    public func transfer(_ target: Structure, resource: ResourceType, amount: Int? = nil) -> ReturnCode {
        transfer(target.jsObject, resource: resource, amount: amount)
    }

    @discardableResult
    public func build(_ target: ConstructionSite) -> ReturnCode {
        returnCode(from: jsObject.build.function!(target.jsObject))
    }

    @discardableResult
    public func repair(_ target: Structure) -> ReturnCode {
        returnCode(from: jsObject.repair.function!(target.jsObject))
    }

    @discardableResult
    public func upgradeController(_ target: StructureController) -> ReturnCode {
        returnCode(from: jsObject.upgradeController.function!(target.jsObject))
    }

    public func say(_ message: String, publicly: Bool = false) {
        _ = jsObject.say.function!(message, publicly)
    }

    @discardableResult
    private func roomMoveTo(_ target: RoomPosition) -> ReturnCode {
        returnCode(from: jsObject.moveTo.function!(target.jsObject))
    }

    @discardableResult
    private func transfer(_ target: JSObject, resource: ResourceType, amount: Int?) -> ReturnCode {
        let result: JSValue
        if let amount {
            result = jsObject.transfer.function!(target, resource.rawValue, amount)
        } else {
            result = jsObject.transfer.function!(target, resource.rawValue)
        }
        return returnCode(from: result)
    }
}

public struct Game {
    let jsObject: JSObject

    public static var shared: Game {
        Game(jsObject: JSBridge.global.Game.object!)!
    }

    init?(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static var memory: ScreepsMemory {
        ScreepsMemory(jsObject: JSBridge.global.Memory.object!)
    }

    public static var rawMemory: RawMemoryProxy {
        RawMemoryProxy(jsObject: JSBridge.global.RawMemory.object!)
    }

    public var time: Int {
        JSBridge.int(jsObject.time) ?? 0
    }

    public var cpu: CPU {
        CPU(jsObject: jsObject.cpu.object!)!
    }

    public var creeps: [String: Creep] {
        JSBridge.typedDictionary(jsObject.creeps.object!, as: Creep.self)
    }

    public var rooms: [String: Room] {
        JSBridge.typedDictionary(jsObject.rooms.object!, as: Room.self)
    }

    public var spawns: [String: StructureSpawn] {
        JSBridge.typedDictionary(jsObject.spawns.object!, as: StructureSpawn.self)
    }

    public var flags: [String: Flag] {
        JSBridge.typedDictionary(jsObject.flags.object!, as: Flag.self)
    }

    public func getObjectById(_ id: ObjectID<Source>) -> Source? {
        jsObject.getObjectById.function!(id.rawValue).object.flatMap(Source.init)
    }

    public func getObjectById(_ id: ObjectID<Creep>) -> Creep? {
        jsObject.getObjectById.function!(id.rawValue).object.flatMap(Creep.init)
    }

    public func getObjectById(_ id: ObjectID<Structure>) -> Structure? {
        jsObject.getObjectById.function!(id.rawValue).object.flatMap(Structure.init)
    }

    public func getObjectById(_ id: ObjectID<StructureSpawn>) -> StructureSpawn? {
        jsObject.getObjectById.function!(id.rawValue).object.flatMap(StructureSpawn.init)
    }

    public func getObjectById(_ id: ObjectID<ConstructionSite>) -> ConstructionSite? {
        jsObject.getObjectById.function!(id.rawValue).object.flatMap(ConstructionSite.init)
    }
}

private func returnCode(from value: JSValue) -> ReturnCode {
    ReturnCode(rawValue: JSBridge.int(value) ?? ReturnCode.invalidArgs.rawValue) ?? .invalidArgs
}
