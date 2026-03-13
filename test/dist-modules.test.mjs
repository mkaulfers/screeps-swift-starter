import test from "node:test";
import assert from "node:assert/strict";
import { mkdtemp, rm, writeFile } from "node:fs/promises";
import path from "node:path";
import os from "node:os";
import { loadDistModules } from "../Scripts/lib/dist-modules.mjs";

test("loadDistModules converts js and wasm files into Screeps modules", async () => {
  const tempDir = await mkdtemp(path.join(os.tmpdir(), "screeps-swift-dist-"));

  try {
    await writeFile(path.join(tempDir, "main.js"), "module.exports.loop = () => 1;\n");
    await writeFile(path.join(tempDir, "ScreepsSwift.wasm"), Buffer.from([0x00, 0x61, 0x73, 0x6d]));
    await writeFile(path.join(tempDir, "manifest.json"), "{}\n");

    const modules = await loadDistModules(tempDir);

    assert.equal(modules.main, "module.exports.loop = () => 1;\n");
    assert.deepEqual(Object.keys(modules).sort(), ["ScreepsSwift", "main"]);
    assert.equal(modules.ScreepsSwift.binary, Buffer.from([0x00, 0x61, 0x73, 0x6d]).toString("base64"));
  } finally {
    await rm(tempDir, { recursive: true, force: true });
  }
});
