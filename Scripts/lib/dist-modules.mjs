import { readdir, readFile } from "node:fs/promises";
import path from "node:path";

export function moduleNameForFile(filename) {
  return path.parse(filename).name;
}

export async function loadDistModules(distDir) {
  const entries = await readdir(distDir, { withFileTypes: true });
  const modules = {};

  for (const entry of entries) {
    if (!entry.isFile()) {
      continue;
    }

    const parsed = path.parse(entry.name);
    if (![".js", ".wasm"].includes(parsed.ext)) {
      continue;
    }

    const absolutePath = path.join(distDir, entry.name);
    const contents = await readFile(absolutePath);
    const moduleName = moduleNameForFile(entry.name);

    if (parsed.ext === ".js") {
      modules[moduleName] = contents.toString("utf8");
    } else {
      modules[moduleName] = {
        binary: contents.toString("base64"),
      };
    }
  }

  return modules;
}
