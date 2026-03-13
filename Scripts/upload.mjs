import { readFile } from "node:fs/promises";
import path from "node:path";
import { createRequire } from "node:module";
import { loadDistModules } from "./lib/dist-modules.mjs";

const require = createRequire(import.meta.url);
const { ScreepsAPI } = require("screeps-api");

const root = process.cwd();
const distDir = path.join(root, "dist");
const screepsConfigPath = path.join(root, "screeps.json");
const args = process.argv.slice(2);

function optionValue(name) {
  const index = args.indexOf(name);
  return index >= 0 ? args[index + 1] : undefined;
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function normalizedPath(value = "/") {
  if (!value.startsWith("/")) {
    return `/${value}`;
  }
  return value;
}

async function loadConfig() {
  let rawConfig;
  try {
    rawConfig = await readFile(screepsConfigPath, "utf8");
  } catch {
    throw new Error("Missing screeps.json. Copy screeps.sample.json to screeps.json and fill in credentials.");
  }

  const destinationName = optionValue("--dest") ?? process.env.DEST ?? "main";
  const parsed = JSON.parse(rawConfig);
  const config = parsed[destinationName];
  assert(config, `Unknown destination '${destinationName}' in screeps.json.`);

  return { destinationName, config };
}

function createApi(config) {
  const options = {
    protocol: config.protocol ?? "https",
    hostname: config.hostname ?? "screeps.com",
    port: config.port ?? 443,
    path: normalizedPath(config.path ?? "/"),
    token: config.token,
  };

  return new ScreepsAPI(options);
}

const { destinationName, config } = await loadConfig();
const branch = config.branch ?? "main";
const modules = await loadDistModules(distDir);
const api = createApi(config);

if (!config.token && config.email && config.password) {
  await api.auth(config.email, config.password, {
    protocol: config.protocol ?? "https",
    hostname: config.hostname ?? "screeps.com",
    port: config.port ?? 443,
    path: normalizedPath(config.path ?? "/"),
  });
}

const response = await api.code.set(branch, modules);
console.log(
  JSON.stringify(
    {
      destination: destinationName,
      branch,
      uploadedModules: Object.keys(modules),
      response: response?.data ?? response,
    },
    null,
    2
  )
);
