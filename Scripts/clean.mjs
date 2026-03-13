import { rm } from "node:fs/promises";
import path from "node:path";

const root = process.cwd();

for (const relativePath of [".build", ".build-wasm", "dist"]) {
  await rm(path.join(root, relativePath), { recursive: true, force: true });
}
