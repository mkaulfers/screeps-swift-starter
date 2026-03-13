import ScreepsKit

private func runStarterBot() {
    let tick: Int = Game.shared.time
    print("Screeps Swift starter tick \(tick)")
}

ScreepsRuntime.install(loop: runStarterBot)