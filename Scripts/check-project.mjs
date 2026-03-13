import { access } from "node:fs/promises";
import path from "node:path";

const root = process.cwd();

const requiredFiles = [
  "Scripts/bootstrap/main.js",
  "Scripts/build.mjs",
  "Scripts/upload.mjs",
  "screeps.sample.json",
  "Sources/ScreepsKit/Generated/ScreepsBindings.generated.swift",
];

for (const relativePath of requiredFiles) {
  const absolutePath = path.join(root, relativePath);
  try {
    await access(absolutePath);
  } catch {
    throw new Error(`Missing required project file: ${relativePath}`);
  }
}

console.log("Project structure looks valid.");
