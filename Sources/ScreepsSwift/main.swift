import JavaScriptKit

func gameLoop() {
    let game = Game.shared
    
    for (name, creep) in game.creeps {
        if creep.energy == 0 {
            let sources = ScreepsJS.global.Game.object!.spawns.object!
            let spawnKeys = JSObject.global.Object.function!.keys(sources).object!
            
            if let firstSpawnKey = spawnKeys[0].string,
               let spawn = sources[firstSpawnKey].object {
                creep.moveTo(spawn)
            }
        } else {
            let controller = ScreepsJS.global.Game.object!.rooms.object![creep.pos?.roomName ?? ""].object!.controller.object!
            if creep.upgradeController(controller) == -9 {
                creep.moveTo(controller)
            }
        }
        
        creep.say("Swift Bot \(game.time)")
    }
}

ScreepsJS.exportLoop(gameLoop)

print("Swift WASM Screeps bot initialized!")