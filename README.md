# Screeps Swift Starter

A Swift/WebAssembly starter for building [Screeps](https://screeps.com/) bots with a workflow modeled after the TypeScript starter, but aimed at Swift developers.

## What This Starter Provides

- A `ScreepsKit` Swift library target for user bot code and typed game wrappers
- A `ScreepsSwift` executable target that becomes the WebAssembly module uploaded to Screeps
- A CommonJS `main.js` bootstrap that loads the uploaded `.wasm` binary module inside Screeps
- Generated Swift enums and metadata sourced from `@types/screeps`
- Type-safe wrappers for core game objects such as `Game`, `Room`, `Creep`, `Source`, `StructureSpawn`, `StructureExtension`, `StructureController`, `Store`, and `RoomPosition`
- Multi-environment deploy scripts similar to the TypeScript starter: `push-main`, `push-pserver`, `push-sim`, `watch-*`
- Swift tests, JS smoke tests, and CI checks

## Architecture

This project does not try to run a local-file Node loader inside Screeps. Instead it uses the runtime model Screeps actually supports:

1. Swift compiles to `ScreepsSwift.wasm`
2. `dist/main.js` loads that binary module using `require("ScreepsSwift")`
3. `dist/javascript-kit-swift.js` provides the JavaScriptKit runtime glue
4. Swift registers the tick handler on `globalThis.__swiftScreepsLoop`
5. `main.js` exports `module.exports.loop` and calls into the registered Swift loop every tick

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

## Project Layout

```text
Package.swift
Sources/
  ScreepsKit/
    API/
    Generated/
    Interop/
    Runtime/
  ScreepsSwift/
    main.swift
Scripts/
  bootstrap/
  lib/
  build.mjs
  generate-bindings.mjs
  upload.mjs
test/
Tests/
```

## Build And Test

Generate bindings from `@types/screeps`:

```bash
npm run generate-bindings
```

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
swift test
npm test
npm run lint
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

The uploader reads every `.js` and `.wasm` file from `dist/`, converts `.wasm` files to Screeps binary modules, and uploads them through the Screeps code API.

## Generated Bindings

`Scripts/generate-bindings.mjs` parses `node_modules/@types/screeps/index.d.ts` and regenerates:

- `ReturnCode`
- `FindConstant`
- `Direction`
- `ColorConstant`
- `BodyPart`
- `LookConstant`
- `StructureType`
- `ResourceType`
- generated interface/global metadata

The generated file lives at `Sources/ScreepsKit/Generated/ScreepsBindings.generated.swift`.

## Swift API Surface

The user-facing API intentionally hides raw `JSObject` values from public method signatures. A few examples:

```swift
let game = Game.shared
let creep = game.creeps["Worker1"]
let sources = creep?.room?.sources ?? []
let controller = creep?.room?.controller
```

```swift
if creep.store[.energy] == 0, let source = creep.room?.sources.first {
    let result = creep.harvest(source)
    if result == .notInRange {
        _ = creep.moveTo(source)
    }
}
```

## Editor Tasks

VS Code/Cursor tasks are provided in `.vscode/tasks.json` for:

- `npm: build`
- `npm: lint`
- `npm: test`
- `npm: push-main`

## Notes

- Native `swift test` validates the library target and generated types on the host machine.
- Full `npm run build` requires a SwiftWasm SDK and will fail with a helpful error until one is installed.
- The current typed wrapper layer focuses on the most important gameplay objects while the generated definitions keep the project aligned with Screeps' declaration source.

## License

MIT. See `LICENSE`.