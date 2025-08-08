# Screeps Swift Starter

A starter kit for developing [Screeps](https://screeps.com/) AI using Swift and WebAssembly.

## Overview

This project provides a foundation for writing Screeps AI bots using Swift compiled to WebAssembly. It includes:

- Swift type definitions for core Screeps game objects
- JavaScript interop layer using JavaScriptKit
- Build tools for compiling Swift to WASM
- Example implementation with basic creep behavior

## Prerequisites

1. **SwiftWasm Toolchain**: Download and install from [SwiftWasm releases](https://github.com/swiftwasm/swift/releases)
2. **Node.js**: For deployment and build tools
3. **Screeps Account**: To deploy and test your bot

## Project Structure

```
screeps-swift-starter/
├── Package.swift                    # Swift package configuration
├── Sources/ScreepsSwift/
│   ├── main.swift                  # Main entry point and game loop
│   ├── Types/
│   │   ├── Game.swift             # Game object type definitions
│   │   └── Creep.swift            # Creep object with basic methods
│   └── Interop/
│       └── JSInterop.swift        # JavaScript interoperability layer
├── build.sh                        # Build script for Unix/Linux/macOS
├── build.bat                       # Build script for Windows
├── package.json                    # NPM configuration
└── README.md                       # This file
```

## Getting Started

1. **Install Dependencies**:
   ```bash
   npm install
   ```

2. **Build the Project**:
   
   **Windows**:
   ```cmd
   npm run build
   ```
   
   **Unix/Linux/macOS**:
   ```bash
   npm run build:unix
   ```

3. **Deploy to Screeps**:
   - Configure `screeps-deploy` with your credentials
   - Run: `npm run deploy`

## Example Bot Behavior

The starter bot implements basic creep behavior:

- **Energy Collection**: Creeps move to spawns when they have no energy
- **Controller Upgrade**: Creeps upgrade the room controller when they have energy
- **Status Display**: Creeps say "Swift Bot [tick]" to show they're working

## Available Types

### Game
- `Game.shared.time`: Current game tick
- `Game.shared.creeps`: Dictionary of all your creeps
- `Game.shared.spawns`: Dictionary of all your spawns

### Creep
- `creep.pos`: Current position (x, y, roomName)
- `creep.energy`: Current energy amount
- `creep.energyCapacity`: Maximum energy capacity
- `creep.moveTo(target)`: Move towards target
- `creep.harvest(source)`: Harvest from energy source
- `creep.transfer(target, resource)`: Transfer resources
- `creep.upgradeController(controller)`: Upgrade room controller
- `creep.say(message)`: Display message above creep

## Adding New Types

To add new Screeps object types:

1. Create a new Swift file in `Sources/ScreepsSwift/Types/`
2. Use JavaScriptKit to wrap the JavaScript object
3. Import the type in `main.swift`
4. Add methods that call the underlying JavaScript API

Example:
```swift
public struct Source {
    private let jsObject: JSObject
    
    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }
    
    public var energy: Int {
        return Int(jsObject.energy.number ?? 0)
    }
}
```

## Development

- **Watch Mode**: `npm run watch` - Automatically rebuilds on Swift file changes
- **Clean Build**: 
  - Windows: `npm run clean` 
  - Unix: `npm run clean:unix`
- **Manual Build**: 
  - Windows: `build.bat` 
  - Unix: `./build.sh`

## Technical Notes

- Uses JavaScriptKit for Swift-JavaScript interop
- Compiles to WebAssembly using SwiftWasm toolchain
- Exports main loop function to Screeps runtime
- Supports all standard Screeps API features through JavaScript bridge

## Contributing

This is a starter template. Feel free to:
- Add more Screeps object type definitions
- Improve the JavaScript interop layer  
- Add utility functions and AI logic
- Submit issues and pull requests

## License

MIT License - See LICENSE file for details