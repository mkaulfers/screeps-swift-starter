import { access } from "node:fs/promises";
import path from "node:path";

const root = process.cwd();

async function exists(targetPath) {
  try {
    await access(targetPath);
    return true;
  } catch {
    return false;
  }
}

const requiredFiles = [
  "Scripts/build.mjs",
  "Scripts/upload.mjs",
  "Scripts/lib/dist-modules.mjs",
  "Scripts/lib/resolve-screepskit-bootstrap.mjs",
  "screeps.sample.json",
  "Sources/ScreepsSwift/main.swift",
];

for (const relativePath of requiredFiles) {
  const absolutePath = path.join(root, relativePath);
  if (!(await exists(absolutePath))) {
    throw new Error(`Missing required project file: ${relativePath}`);
  }
}

if (await exists(path.join(root, "Sources", "ScreepsKit"))) {
  throw new Error("Starter should not contain a local Sources/ScreepsKit directory after the repo split.");
}

console.log("Project structure looks valid.");
