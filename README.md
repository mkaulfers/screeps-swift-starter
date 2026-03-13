# Screeps Swift Starter

Write a Screeps bot in Swift, compile it to WebAssembly, and deploy it to Screeps.

## Requirements

- Node.js 20+
- Swift 6+
- A SwiftWasm SDK installed with `swift sdk install`
- A Screeps auth token for the official server, or username/password for a private server

Install a SwiftWasm SDK. Example:

```bash
 swift sdk install https://download.swift.org/swift-6.2.4-release/wasm-sdk/swift-6.2.4-RELEASE/swift-6.2.4-RELEASE_wasm.artifactbundle.tar.gz --checksum 32fdb8772d73bb174f77b5c59bc88a0d55003d75712832129394d3465158fb43
```

If your SDK installs under a different name, set:

```bash
export SWIFT_WASM_SDK=wasm32-unknown-wasip1
```

## Setup

Install dependencies:

```bash
npm install
swift package resolve
```

Create your Screeps config:

```bash
cp screeps.sample.json screeps.json
```

Then edit `screeps.json` with your credentials and target branch.

If you want to run a local private server, use the Docker setup in `Server/`.
It uses the `screepers/screeps-launcher` image with MongoDB and Redis.

Quick start:

```bash
cp Server/screeps/config.example.yml Server/screeps/config.yml
docker compose -f Server/docker-compose.yml up -d
```

Then deploy to your local server with:

```bash
npm run push-pserver
```

See `Server/README.md` for the full setup and CLI workflow.

## Write Your Bot

Edit `Sources/ScreepsSwift/main.swift`.

Minimal example:

```swift
import ScreepsKit

private func runStarterBot() {
    let game = Game.shared
    for creep in game.creeps.values {
        creep.say("Hello \(game.time)")
    }
}

ScreepsRuntime.install(loop: runStarterBot)
```

## Build

Compile the bot and generate the deployable Screeps modules:

```bash
npm run build
```

This produces:

- `dist/main.js`
- `dist/ScreepsSwift.wasm`
- `dist/javascript-kit-swift.js`

## Deploy

Push to the official server:

```bash
npm run push-main
```

Push to simulation:

```bash
npm run push-sim
```

Push to a private server:

```bash
npm run push-pserver
```

Watch and automatically rebuild/deploy:

```bash
npm run watch-main
```

## Verify

Optional checks:

```bash
npm run lint
npm test
swift test
```

## Notes

- The Screeps API and runtime glue are provided by the external `ScreepsKit` package, so you only need to work in your bot code and deployment config.
- If `npm run build` says no WASM SDK is installed, install SwiftWasm first and rerun the command.

## License

MIT. See `LICENSE`.