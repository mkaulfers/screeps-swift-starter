"use strict";

const { SwiftRuntime } = require("javascript-kit-swift");

const LOOP_SYMBOL = "__swiftScreepsLoop";
const READY_SYMBOL = "__swiftScreepsReady";
const wasmBytecode = require("ScreepsSwift");

let runtime = null;
let wasmInstance = null;
let bootError = null;

function initialize() {
  if (wasmInstance || bootError) {
    return;
  }

  try {
    runtime = new SwiftRuntime();
    const module = new WebAssembly.Module(wasmBytecode);
    wasmInstance = new WebAssembly.Instance(module, runtime.wasmImports);
    runtime.setInstance(wasmInstance);
    runtime.main();

    if (typeof globalThis[LOOP_SYMBOL] !== "function") {
      throw new Error(
        `Swift runtime initialized but did not register ${LOOP_SYMBOL}. ` +
          "Make sure ScreepsRuntime.install(loop:) is called from Swift main."
      );
    }

    globalThis[READY_SYMBOL] = true;
  } catch (error) {
    bootError = error;
    console.log("[screeps-swift] Failed to initialize Swift WASM runtime:", error.stack || error);
  }
}

module.exports.loop = function loop() {
  initialize();

  if (bootError) {
    throw bootError;
  }

  if (typeof globalThis[LOOP_SYMBOL] !== "function") {
    throw new Error(`Missing exported Swift loop: ${LOOP_SYMBOL}`);
  }

  return globalThis[LOOP_SYMBOL]();
};
