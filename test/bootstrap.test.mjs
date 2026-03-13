import test from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import path from "node:path";
import vm from "node:vm";

test("bootstrap registers and reuses the exported Swift loop", async () => {
  const source = await readFile(path.join(process.cwd(), "Scripts", "bootstrap", "main.js"), "utf8");

  let runtimeMainCalls = 0;
  let exportedLoopCalls = 0;
  const module = { exports: {} };
  const sandbox = {
    console,
    module,
    exports: module.exports,
    require(name) {
      if (name === "javascript-kit-swift") {
        return { SwiftRuntime: MockSwiftRuntime };
      }
      if (name === "ScreepsSwift") {
        return Buffer.from([0x00, 0x61, 0x73, 0x6d]);
      }
      throw new Error(`Unexpected module request: ${name}`);
    },
    WebAssembly: {
      Module: function Module(bytecode) {
        this.bytecode = bytecode;
      },
      Instance: function Instance(moduleValue, imports) {
        this.module = moduleValue;
        this.imports = imports;
        this.exports = {};
      },
    },
  };

  class MockSwiftRuntime {
    constructor() {
      this.wasmImports = { javascript_kit: {} };
    }

    setInstance(instance) {
      this.instance = instance;
    }

    main() {
      runtimeMainCalls += 1;
      sandbox.__swiftScreepsLoop = () => {
        exportedLoopCalls += 1;
      };
    }
  }

  sandbox.globalThis = sandbox;

  const context = vm.createContext(sandbox);

  new vm.Script(source, { filename: "bootstrap/main.js" }).runInContext(context);

  assert.equal(typeof module.exports.loop, "function");
  module.exports.loop();
  module.exports.loop();

  assert.equal(runtimeMainCalls, 1);
  assert.equal(exportedLoopCalls, 2);
});
