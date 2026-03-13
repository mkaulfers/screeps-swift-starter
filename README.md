# Screeps Swift Starter

A thin starter/template repository for writing Screeps bots in Swift and compiling them to WebAssembly.

The reusable runtime, typed API wrappers, generated bindings, and JS bootstrap now live in the separate `ScreepsKit` Swift package:

- `https://github.com/mkaulfers/ScreepsKit`

This starter is intentionally focused on what end users actually change:

- bot code in `Sources/ScreepsSwift/main.swift`
- deployment configuration in `screeps.json`
- starter-specific build, upload, and watch scripts

## What This Repo Does

- Builds the `ScreepsSwift` executable product to `ScreepsSwift.wasm`
- Copies the `ScreepsKit` bootstrap into `dist/main.js`
- Copies the JavaScriptKit runtime into `dist/javascript-kit-swift.js`
- Uploads `.js` and `.wasm` Screeps modules to your selected branch

## Requirements

- Node.js 20+
- Swift 6+
- A SwiftWasm SDK installed via `swift sdk install`
- A Screeps auth token for official servers, or username/password for private servers

## Install

```bash
npm install
swift package resolve
```

Install a SwiftWasm SDK before building. One example:

```bash
swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-6.0.2-RELEASE/swift-wasm-6.0.2-RELEASE-wasm32-unknown-wasip1.artifactbundle.tar.gz
```

If your SDK name differs, set `SWIFT_WASM_SDK` before building:

```bash
export SWIFT_WASM_SDK=wasm32-unknown-wasip1
```

## Where To Write Code

Your main bot logic lives here:

```swift
import ScreepsKit

private func runStarterBot() {
    let game = Game.shared
    // your bot logic
}

ScreepsRuntime.install(loop: runStarterBot)
```

See `Sources/ScreepsSwift/main.swift`.

## Build And Test

Build the full Screeps distribution:

```bash
npm run build
```

Build only the JS/bootstrap assets without compiling Swift:

```bash
node Scripts/build.mjs --skip-swift
```

Run checks:

```bash
npm run lint
npm test
swift test
```

## Deployment

Copy `screeps.sample.json` to `screeps.json` and fill in the target credentials.

Official server:

```bash
npm run push-main
```

Simulation:

```bash
npm run push-sim
```

Private server:

```bash
npm run push-pserver
```

Watch and deploy on change:

```bash
npm run watch-main
```

The uploader reads `.js` and `.wasm` files from `dist/`, converts `.wasm` files into Screeps binary modules, and uploads them through the Screeps code API.

## Repo Layout

```text
Package.swift
Sources/
  ScreepsSwift/
    main.swift
Scripts/
  build.mjs
  upload.mjs
  clean.mjs
  check-project.mjs
  lib/
test/
screeps.sample.json
```

## Editor Tasks

VS Code/Cursor tasks are provided in `.vscode/tasks.json` for:

- `npm: build`
- `npm: lint`
- `npm: test`
- `npm: push-main`

## Notes

- `ScreepsKit` is consumed via SwiftPM; starter users do not need to regenerate bindings or edit runtime internals.
- Full `npm run build` requires a SwiftWasm SDK and will fail with a helpful error until one is installed.
- `node Scripts/build.mjs --skip-swift` still needs the `ScreepsKit` package dependency resolved so the bootstrap asset can be located.

## License

MIT. See `LICENSE`.