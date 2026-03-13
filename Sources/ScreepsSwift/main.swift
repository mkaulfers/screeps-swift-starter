import ScreepsKit

private func runStarterBot() {
    let game = Game.shared
    let creeps = game.creeps.values.sorted { $0.name < $1.name }

    for creep in creeps {
        guard let room = creep.room else {
            continue
        }

        if creep.store[.energy] == 0 {
            if let source = room.activeSources.first ?? room.sources.first {
                let result = creep.harvest(source)
                if result == .notInRange {
                    _ = creep.moveTo(source)
                }
            }

            creep.say("Harvest")
            continue
        }

        if let spawn = room.mySpawns.first(where: { $0.store.freeCapacity(for: .energy) > 0 }) {
            let result = creep.transfer(spawn, resource: .energy)
            if result == .notInRange {
                _ = creep.moveTo(spawn)
            }
            creep.say("Refill")
            continue
        }

        if let extensionStructure = room.myExtensions.first(where: { $0.store.freeCapacity(for: .energy) > 0 }) {
            let result = creep.transfer(extensionStructure, resource: .energy)
            if result == .notInRange {
                _ = creep.moveTo(extensionStructure)
            }
            creep.say("Charge")
            continue
        }

        if let controller = room.controller {
            let result = creep.upgradeController(controller)
            if result == .notInRange {
                _ = creep.moveTo(controller)
            }
            creep.say("Swift \(game.time)")
        }
    }
}

ScreepsRuntime.install(loop: runStarterBot)