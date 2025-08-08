#!/bin/bash

set -e

echo "Building Screeps Swift WASM..."

# Check if SwiftWasm is installed
if ! command -v swift &> /dev/null; then
    echo "Error: Swift compiler not found. Please install SwiftWasm toolchain."
    echo "Download from: https://github.com/swiftwasm/swift/releases"
    exit 1
fi

# Create dist directory
mkdir -p dist

# Build the Swift package for WASM
echo "Compiling Swift to WebAssembly..."
swift build --triple wasm32-unknown-wasi --build-path .build-wasm -c release

# Check if the WASM file was created
WASM_FILE=".build-wasm/wasm32-unknown-wasi/release/ScreepsSwift.wasm"
if [ ! -f "$WASM_FILE" ]; then
    echo "Error: WASM file not generated at $WASM_FILE"
    exit 1
fi

# Copy WASM file to dist
cp "$WASM_FILE" dist/

# Create JavaScript wrapper
cat > dist/main.js << 'EOF'
const fs = require('fs');
const path = require('path');

let wasmInstance = null;
let wasmMemory = null;

// Load WASM module
async function loadWasm() {
    const wasmPath = path.join(__dirname, 'ScreepsSwift.wasm');
    const wasmBuffer = fs.readFileSync(wasmPath);
    
    const wasmModule = await WebAssembly.compile(wasmBuffer);
    
    const importObject = {
        wasi_snapshot_preview1: {
            // Add WASI functions as needed
            proc_exit: () => {},
            fd_write: () => 0,
            fd_close: () => 0,
            fd_seek: () => 0,
            path_open: () => 0,
            // Add more WASI functions as required
        },
        env: {
            // JavaScript functions that can be called from Swift
        }
    };
    
    wasmInstance = await WebAssembly.instantiate(wasmModule, importObject);
    wasmMemory = wasmInstance.exports.memory;
    
    // Call the Swift main function to initialize
    if (wasmInstance.exports._start) {
        wasmInstance.exports._start();
    }
    
    return wasmInstance;
}

// Initialize and export the loop function
async function initialize() {
    try {
        await loadWasm();
        console.log('Swift WASM module loaded successfully');
    } catch (error) {
        console.error('Failed to load Swift WASM module:', error);
    }
}

// Export for Screeps
module.exports.loop = function() {
    if (!wasmInstance) {
        console.log('WASM not yet loaded, initializing...');
        initialize();
        return;
    }
    
    // The actual loop function will be set by Swift via ScreepsJS.exportLoop
    if (global.swiftLoop) {
        global.swiftLoop();
    }
};

// Initialize the module
initialize();
EOF

echo "Build completed successfully!"
echo "Generated files:"
echo "  - dist/ScreepsSwift.wasm"
echo "  - dist/main.js"
echo ""
echo "To deploy to Screeps:"
echo "  1. Configure screeps-deploy with your credentials"
echo "  2. Run: npm run deploy"