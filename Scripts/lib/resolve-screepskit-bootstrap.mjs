import { access } from "node:fs/promises";
import path from "node:path";

async function exists(targetPath) {
  try {
    await access(targetPath);
    return true;
  } catch {
    return false;
  }
}

export async function resolveScreepsKitBootstrap(root) {
  const candidates = [
    path.join(root, ".build-wasm", "checkouts", "ScreepsKit", "Scripts", "bootstrap", "main.js"),
    path.join(root, ".build", "checkouts", "ScreepsKit", "Scripts", "bootstrap", "main.js"),
    path.join(root, "..", "ScreepsKit", "Scripts", "bootstrap", "main.js"),
  ];

  for (const candidate of candidates) {
    if (await exists(candidate)) {
      return candidate;
    }
  }

  return null;
}
