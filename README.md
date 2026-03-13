# Screeps Swift Starter

Write a Screeps bot in Swift, compile it to WebAssembly, and deploy it to Screeps.

## Requirements

- Node.js 20+
- Swift 6+
- A SwiftWasm SDK installed with `swift sdk install`
- A Screeps auth token for the official server, or username/password for a private server

Install a SwiftWasm SDK. Example:

```bash
swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-6.0.2-RELEASE/swift-wasm-6.0.2-RELEASE-wasm32-unknown-wasip1.artifactbundle.tar.gz
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