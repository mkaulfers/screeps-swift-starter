// This file is generated from @types/screeps. Do not edit directly.

public enum ReturnCode: Int, CaseIterable, Sendable {
    case ok = 0
    case notOwner = -1
    case noPath = -2
    case nameExists = -3
    case busy = -4
    case notFound = -5
    case notEnoughResources = -6
    case invalidTarget = -7
    case full = -8
    case notInRange = -9
    case invalidArgs = -10
    case tired = -11
    case noBodypart = -12
    case rclNotEnough = -14
    case gclNotEnough = -15
}

public extension ReturnCode {
    static let notEnoughEnergy = ReturnCode(rawValue: -6)!
    static let notEnoughExtensions = ReturnCode(rawValue: -6)!
}

public enum FindConstant: Int, CaseIterable, Sendable {
    case exitTop = 1
    case exitRight = 3
    case exitBottom = 5
    case exitLeft = 7
    case exit = 10
    case creeps = 101
    case myCreeps = 102
    case hostileCreeps = 103
    case sourcesActive = 104
    case sources = 105
    case droppedResources = 106
    case structures = 107
    case myStructures = 108
    case hostileStructures = 109
    case flags = 110
    case constructionSites = 111
    case mySpawns = 112
    case hostileSpawns = 113
    case myConstructionSites = 114
    case hostileConstructionSites = 115
    case minerals = 116
    case nukes = 117
    case tombstones = 118
    case powerCreeps = 119
    case myPowerCreeps = 120
    case hostilePowerCreeps = 121
    case deposits = 122
    case ruins = 123
}

public enum Direction: Int, CaseIterable, Sendable {
    case top = 1
    case topRight = 2
    case right = 3
    case bottomRight = 4
    case bottom = 5
    case bottomLeft = 6
    case left = 7
    case topLeft = 8
}

public enum ColorConstant: Int, CaseIterable, Sendable {
    case red = 1
    case purple = 2
    case blue = 3
    case cyan = 4
    case green = 5
    case yellow = 6
    case orange = 7
    case brown = 8
    case grey = 9
    case white = 10
}

public enum BodyPart: String, CaseIterable, Sendable {
    case move = "move"
    case work = "work"
    case carry = "carry"
    case attack = "attack"
    case rangedAttack = "ranged_attack"
    case tough = "tough"
    case heal = "heal"
    case claim = "claim"
}

public enum LookConstant: String, CaseIterable, Sendable {
    case creeps = "creep"
    case energy = "energy"
    case resources = "resource"
    case sources = "source"
    case minerals = "mineral"
    case deposits = "deposit"
    case structures = "structure"
    case flags = "flag"
    case constructionSites = "constructionSite"
    case nukes = "nuke"
    case terrain = "terrain"
    case tombstones = "tombstone"
    case powerCreeps = "powerCreep"
    case ruins = "ruin"
}

public enum StructureType: String, CaseIterable, Sendable {
    case structureExtension = "extension"
    case rampart = "rampart"
    case road = "road"
    case spawn = "spawn"
    case link = "link"
    case wall = "constructedWall"
    case keeperLair = "keeperLair"
    case controller = "controller"
    case storage = "storage"
    case tower = "tower"
    case observer = "observer"
    case powerBank = "powerBank"
    case powerSpawn = "powerSpawn"
    case extractor = "extractor"
    case lab = "lab"
    case terminal = "terminal"
    case container = "container"
    case nuker = "nuker"
    case factory = "factory"
    case invaderCore = "invaderCore"
    case portal = "portal"
}

public enum ResourceType: String, CaseIterable, Sendable {
    case energy = "energy"
    case power = "power"
    case ops = "ops"
    case utrium = "U"
    case lemergium = "L"
    case keanium = "K"
    case ghodium = "G"
    case zynthium = "Z"
    case oxygen = "O"
    case hydrogen = "H"
    case catalyst = "X"
    case hydroxide = "OH"
    case zynthiumKeanite = "ZK"
    case utriumLemergite = "UL"
    case utriumHydride = "UH"
    case utriumOxide = "UO"
    case keaniumHydride = "KH"
    case keaniumOxide = "KO"
    case lemergiumHydride = "LH"
    case lemergiumOxide = "LO"
    case zynthiumHydride = "ZH"
    case zynthiumOxide = "ZO"
    case ghodiumHydride = "GH"
    case ghodiumOxide = "GO"
    case utriumAcid = "UH2O"
    case utriumAlkalide = "UHO2"
    case keaniumAcid = "KH2O"
    case keaniumAlkalide = "KHO2"
    case lemergiumAcid = "LH2O"
    case lemergiumAlkalide = "LHO2"
    case zynthiumAcid = "ZH2O"
    case zynthiumAlkalide = "ZHO2"
    case ghodiumAcid = "GH2O"
    case ghodiumAlkalide = "GHO2"
    case catalyzedUtriumAcid = "XUH2O"
    case catalyzedUtriumAlkalide = "XUHO2"
    case catalyzedKeaniumAcid = "XKH2O"
    case catalyzedKeaniumAlkalide = "XKHO2"
    case catalyzedLemergiumAcid = "XLH2O"
    case catalyzedLemergiumAlkalide = "XLHO2"
    case catalyzedZynthiumAcid = "XZH2O"
    case catalyzedZynthiumAlkalide = "XZHO2"
    case catalyzedGhodiumAcid = "XGH2O"
    case catalyzedGhodiumAlkalide = "XGHO2"
    case biomass = "biomass"
    case metal = "metal"
    case mist = "mist"
    case silicon = "silicon"
    case utriumBar = "utrium_bar"
    case lemergiumBar = "lemergium_bar"
    case zynthiumBar = "zynthium_bar"
    case keaniumBar = "keanium_bar"
    case ghodiumMelt = "ghodium_melt"
    case oxidant = "oxidant"
    case reductant = "reductant"
    case purifier = "purifier"
    case battery = "battery"
    case composite = "composite"
    case crystal = "crystal"
    case liquid = "liquid"
    case wire = "wire"
    case switchResource = "switch"
    case transistor = "transistor"
    case microchip = "microchip"
    case circuit = "circuit"
    case device = "device"
    case cell = "cell"
    case phlegm = "phlegm"
    case tissue = "tissue"
    case muscle = "muscle"
    case organoid = "organoid"
    case organism = "organism"
    case alloy = "alloy"
    case tube = "tube"
    case fixtures = "fixtures"
    case frame = "frame"
    case hydraulics = "hydraulics"
    case machine = "machine"
    case condensate = "condensate"
    case concentrate = "concentrate"
    case extract = "extract"
    case spirit = "spirit"
    case emanation = "emanation"
    case essence = "essence"
}

public enum GeneratedInterfaceName: String, CaseIterable, Sendable {
    case allLookAtTypes = "AllLookAtTypes"
    case circleStyle = "CircleStyle"
    case concreteStructureMap = "ConcreteStructureMap"
    case constructionSite = "ConstructionSite"
    case costMatrix = "CostMatrix"
    case cpu = "CPU"
    case cpushardLimits = "CPUShardLimits"
    case creep = "Creep"
    case creepMemory = "CreepMemory"
    case deposit = "Deposit"
    case eventData = "EventData"
    case filterObject = "FilterObject"
    case filterOptions = "FilterOptions"
    case findPathOpts = "FindPathOpts"
    case findTypes = "FindTypes"
    case flag = "Flag"
    case flagMemory = "FlagMemory"
    case game = "Game"
    case gameMap = "GameMap"
    case genericStoreBase = "GenericStoreBase"
    case globalControlLevel = "GlobalControlLevel"
    case globalPowerLevel = "GlobalPowerLevel"
    case heapStatistics = "HeapStatistics"
    case interShardMemory = "InterShardMemory"
    case lineStyle = "LineStyle"
    case lookAtResultMatrix = "LookAtResultMatrix"
    case lookForAtAreaResultMatrix = "LookForAtAreaResultMatrix"
    case mapCircleStyle = "MapCircleStyle"
    case mapLineStyle = "MapLineStyle"
    case mapPolyStyle = "MapPolyStyle"
    case mapTextStyle = "MapTextStyle"
    case mapVisual = "MapVisual"
    case market = "Market"
    case memory = "Memory"
    case mineral = "Mineral"
    case moveToOpts = "MoveToOpts"
    case naturalEffect = "NaturalEffect"
    case nuke = "Nuke"
    case order = "Order"
    case orderFilter = "OrderFilter"
    case ownedStructure = "OwnedStructure"
    case owner = "Owner"
    case pathFinder = "PathFinder"
    case pathFinderOpts = "PathFinderOpts"
    case pathFinderPath = "PathFinderPath"
    case pathStep = "PathStep"
    case polyStyle = "PolyStyle"
    case powerClass = "POWER_CLASS"
    case powerCreep = "PowerCreep"
    case powerCreepMemory = "PowerCreepMemory"
    case powerCreepPowers = "PowerCreepPowers"
    case powerEffect = "PowerEffect"
    case priceHistory = "PriceHistory"
    case rawMemory = "RawMemory"
    case reservationDefinition = "ReservationDefinition"
    case resource = "Resource"
    case room = "Room"
    case roomMemory = "RoomMemory"
    case roomObject = "RoomObject"
    case roomPosition = "RoomPosition"
    case roomStatusPermanent = "RoomStatusPermanent"
    case roomStatusTemporary = "RoomStatusTemporary"
    case roomTerrain = "RoomTerrain"
    case routeOptions = "RouteOptions"
    case ruin = "Ruin"
    case shard = "Shard"
    case signDefinition = "SignDefinition"
    case source = "Source"
    case spawning = "Spawning"
    case spawnMemory = "SpawnMemory"
    case spawnOptions = "SpawnOptions"
    case storeBase = "StoreBase"
    case structure = "Structure"
    case structureContainer = "StructureContainer"
    case structureController = "StructureController"
    case structureExtension = "StructureExtension"
    case structureExtractor = "StructureExtractor"
    case structureFactory = "StructureFactory"
    case structureInvaderCore = "StructureInvaderCore"
    case structureKeeperLair = "StructureKeeperLair"
    case structureLab = "StructureLab"
    case structureLink = "StructureLink"
    case structureNuker = "StructureNuker"
    case structureObserver = "StructureObserver"
    case structurePortal = "StructurePortal"
    case structurePowerBank = "StructurePowerBank"
    case structurePowerSpawn = "StructurePowerSpawn"
    case structureRampart = "StructureRampart"
    case structureRoad = "StructureRoad"
    case structureSpawn = "StructureSpawn"
    case structureStorage = "StructureStorage"
    case structureTerminal = "StructureTerminal"
    case structureTower = "StructureTower"
    case structureWall = "StructureWall"
    case survivalGameInfo = "SurvivalGameInfo"
    case textStyle = "TextStyle"
    case tombstone = "Tombstone"
    case transaction = "Transaction"
    case transactionOrder = "TransactionOrder"
}

public enum GeneratedGlobalName: String, CaseIterable, Sendable {
    case game = "Game"
}

